#!/bin/env ruby

require "socket"
require 'rubygems' if RUBY_VERSION < "1.9"
require 'json'

class KLMQ_bind

  def initialize(logger=nil)
    @server_bind = UDPSocket.new
    @logger = logger
  end

  def bind(host, port)
    puts "--------------------------------"
    puts "--   Kevin Lee Message Queue  --"
    puts "--   Bind IP #{host}  --"
    puts "--   Bind Port #{port}        --"
    puts "--------------------------------"
    @server_bind.bind(host, port)
  end

  def recieve()
    while true
      recv_data = @server_bind.recvfrom(1024)
      trip(recv_data)
    end
  end
  def trip(data)
    json_data = JSON.parse(data[0])
    if json_data.has_key?("cmd") and json_data.has_key?("need_response")
      res = IO.popen(json_data["cmd"])
      reply(data[1],json_data["response_port"], res.readlines.join) if json_data["need_response"]  == "yes"
    end
    if json_data.has_key?("response")
      p json_data["response"]
    end
  end

  def reply(data, rep_port, res)
    res_hash = {}
    res_hash["response"] = res
    res_json = res_hash.to_json
    host = data[data.size - 1]
    @res_server = UDPSocket.new
    @res_server.send(res_json, 0, host, rep_port)
  end
end
