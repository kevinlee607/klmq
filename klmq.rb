#!/bin/env -f ruby

require "socket"
require "getoptlong"
require "rdoc/usage"
require File.join(File.dirname(__FILE__), "lib/klmq_bind")

opts = GetoptLong.new(
  ['--help', '-h', GetoptLong::OPTIONAL_ARGUMENT],
  ['--port', '-p', GetoptLong::OPTIONAL_ARGUMENT],
  ['--host', '-i', GetoptLong::OPTIONAL_ARGUMENT]
)
port = nil
host = nil

opts.each do |opt, arg|
  case opt 
    when '--help'
      RDoc::usage
    when '--port'
      port = arg.to_i
    when '--host'
      host = arg
  end
end

if port.nil? or port.size <= 0
  port = 8888
end
if host.nil? or host.size <= 0
  host = "0.0.0.0"
end

srv_bind = KLMQ_bind.new()
srv_bind.bind(host,port)
srv_bind.recieve
