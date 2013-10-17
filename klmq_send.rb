#!/bin/env -f ruby

require 'rubygems' if RUBY_VERSION < "1.9"
require 'json'
require "socket"

cmd_hash = {}
cmd_hash["cmd"] = "/etc/init.d/openstack-nova-api status"
cmd_hash["need_response"] = "yes"
cmd_hash["response_port"] = 8888
cmd_json = cmd_hash.to_json
s1 = UDPSocket.new
s1.send(cmd_json, 0, "9.110.51.132", 8888)

