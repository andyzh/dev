#!/var/vcap/bosh/bin/ruby
#
require "yaml"
require "optparse"
require "fileutils"
require 'uuidtools'

INSTALLPATH = File.dirname(__FILE__)

def run_client(options)
  `sh #{INSTALLPATH}/dist/runjava.sh com.rabbitmq.examples.MulticastMain \
    #{options["ack"] ? "-a" : ""} \
    -t #{options["exchange_type"]} \
    #{options["persistent"] ? "-f persistent" : ""} \
    -x #{options["p_num"]} \
    -h #{options["url"]} \
    -q #{options["qos"]} \
    -c 1 \
    -z #{options["time"]} \
    -s #{options["per_size"]} \
    -r #{options["rate_limit"]} \
    -u #{options["q_name"]} \
    -y #{options["c_num"]} >> #{$out_file}`
end

def run_client_pre(options)
  `sh #{INSTALLPATH}/dist/runjava.sh com.rabbitmq.examples.MulticastMain \
    -t #{options["exchange_type"]} \
    #{options["persistent"] ? "-f persistent" : ""} \
    -h #{options["url"]} \
    -s #{options["per_size"]} \
    -x 1 \
    -u #{options["q_name"]} \
    -C #{options["p_count"]} \
    -y 0 1>/dev/null`
end

$config_file = nil
OptionParser.new do |op|
  op.banner = <<-EOF
  Usage: app.rb -c <config_file>
EOF
  op.on("-c config_file") do |cf|
    $config_file = cf
  end
end.parse!

def stop
  `pkill -9 -f app.rb.*start`
  `pkill -9 -f app.rb.*preload`
  `killall -9 java`
end

def init
  Process.daemon
  if !$config_file || !File.exists?($config_file)
    puts "Config File Not Exists"
    exit(-1)
  end

  $conf = YAML.load_file($config_file)
  $url = $conf['credential']['url']
  java = $conf['java']
  ENV["PATH"] = java + ":" + ENV["PATH"]
  out_dir = $conf['output_dir']
  $out_file = File.join(out_dir, UUIDTools::UUID.random_create.to_s + ".log")
end

def preload
  init
  `echo "Start Preload At #{Time.now}" >> #{$out_file}`
  preload_size = $conf['preload_size']

  per_total = preload_size / $conf['scenarios'].size
  $conf['scenarios'].each do |s|
    p_thread = Thread.new do
      per_size = Random.new(1235).rand(100..200)
      s_pre = s.merge("q_name" => s["name"], "url" => $url, "p_count" => per_total / per_size + 1, "per_size" => per_size)
      run_client_pre(s_pre)
    end

    force_kill = true
    20.times do
      sleep 1
      if !p_thread.alive?
        force_kill = false
        p_thread.join
        break
      end
    end
    if force_kill
      `ps aux | grep '#{$url}' | awk '{print $2}' | xargs kill -9 2>/dev/null`
    end
  end
end

def start
  init
  msg_min = $conf['load_setting']['minsize']
  msg_max = $conf['load_setting']['maxsize']
  p_num = $conf['load_setting']['p_num']
  c_num = $conf['load_setting']['c_num']
  rate_limit = $conf['load_setting']['ratelimit']
  java = $conf['java']
  ENV["PATH"] = java + ":" + ENV["PATH"]

  `echo "Start Test At #{Time.now}" >> #{$out_file}`

  while true do
    $conf['scenarios'].shuffle.each do |s|
      st_time = Time.now.to_i
      invalid = false
      invalid_key = nil
      ['time', 'exchange_type'].each do |k|
        if s[k] == nil
          invalid_key = k
          invalid = true
          break
        end
      end
      if invalid
        puts "Invalid Config For #{invalid_key}"
        next
      end
      nt = Thread.new do
        s.merge!("q_name" => s['name'], "url" => $url, "p_num" => p_num, "c_num" => c_num, "rate_limit" => rate_limit, "per_size" => Random.new(2345).rand(msg_min..msg_max))
        run_client(s)
        puts "Done #{s["name"]}"
      end
      sleep s['time'] + 1
      `ps aux | grep '#{$url}' | awk '{print $2}' | xargs kill -9 2>/dev/null`
      nt.join
      `echo "Finish #{s["name"]} In #{Time.now.to_i - st_time}" >> #{$out_file}`
      `echo "Finish All At #{Time.now}" >> #{$out_file}`
    end
  end
  puts "Finish Test At #{Time.now}"
end

send(ARGV[0].to_sym)
