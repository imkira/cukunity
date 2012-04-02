require 'singleton'
require 'socket'
require 'json'

module Cukunity
  module IOS
    class UIAutomationSlave
      def exchange(host, port, result = {})
        sock = TCPSocket.new(host, port)
        begin
          sock.puts result.to_json
          JSON.parse(sock.gets.chomp)
        ensure
          sock.close unless sock.nil?
        end
      end
    end
  end
end

if __FILE__ == $0
  begin
    # read commands (no error handling)
    host = ARGV.shift
    port = ARGV.shift.to_i
    result = JSON.parse(ARGV.shift)
    # create client
    slave = Cukunity::IOS::UIAutomationSlave.new
    # send result of previous command and wait for new
    command = slave.exchange(host, port, result).to_json
    # print out new command
    puts command
    exit(0)
  rescue Errno::ECONNREFUSED => err
    $stderr.puts "Error: #{err}"
    exit(2)
  rescue => err
    $stderr.puts "Error: #{err}"
    exit(1)
  end
end
