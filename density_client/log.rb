#!/usr/bin/env ruby
require 'thread'
MAX_SIZE = 20

$latency_min = 0;
$latency_avg = 0;
$latency_max = 0;
$latency_cnt = 0;
target_dir = ARGV[0]

def stat(queue)
  while queue.size > 0
    data = queue.pop
    $latency_min = data[:min] if $latency_min == 0 or $latency_min > data[:min]
    $latency_max = data[:max] if $latency_max == 0 or $latency_max < data[:max]
    $latency_avg = (data[:avg] + $latency_avg * $latency_cnt)/($latency_cnt + 1)
    $latency_cnt += 1
  end
end
$a = 0

Dir.glob(File.join(target_dir, "**/*")).each do |file|
  if file.end_with?(".log")
    queue = Queue.new
    File.open(file).lines do |line|
      if line =~ / latency: (\d+)\/(\d+)\/(\d+) microseconds/ and $2.to_i < 1000000
        queue.pop if queue.size >= MAX_SIZE
        queue.push({:min => $1.to_f, :avg => $2.to_f, :max => $3.to_f})
        $a += 1
      end
    end
    stat(queue)
  end
end
puts "min/avg/max: #{$latency_min}/#{$latency_avg}/#{$latency_max}"
puts $a
