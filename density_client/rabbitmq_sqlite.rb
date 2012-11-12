require 'data_mapper'

module VCAP
  module Services
    module Rabbit
      class Node
        class ProvisionedService
          include DataMapper::Resource
          property :name,            String,      :key => true
          property :vhost,           String,      :required => true
          property :port,            Integer,     :unique => true
          property :admin_port,      Integer,     :unique => true
          property :admin_username,  String,      :required => true
          property :admin_password,  String,      :required => true
          property :plan,            Integer,     :required => true
          property :plan_option,     String,      :required => false
          property :pid,             Integer
          property :memory,          Integer,     :required => true
          property :status,          Integer,     :default => 0
          property :container,       String
          property :ip,              String
        end
      end
    end
  end
end


def load_sqlite(path, node_host)
  ret = []
  DataMapper::setup(:default, path)
  ps = VCAP::Services::Rabbit::Node::ProvisionedService
  ps.all.each do |svc|
    ret << {
      "name"        => svc[:name],
      "url"         => "amqp://#{svc[:admin_username]}:#{svc[:admin_password]}@#{node_host}:#{svc[:port]}/#{svc[:vhost]}",
    }
  end
  ret
end
