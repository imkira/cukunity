require 'singleton'
require 'socket'
require 'json'
require 'thread'

module Cukunity
  module IOS
    class UIAutomationMaster
      include Singleton
      include Cukunity::Utils

      DEFAULT_HOSTNAME = '127.0.0.1'
      DEFAULT_PORT = 9927
      UIAUTOMATION_SLAVE_DEFAULT_TIMEOUT = 30

      def initialize
        @server = nil
        @client = nil
        @client_mutex = Mutex.new
        @client_acquired = ConditionVariable.new
        @client_finished = ConditionVariable.new
      end

      def command(name, options = {})
        options = merge_options(options, { :max_time => UIAUTOMATION_SLAVE_DEFAULT_TIMEOUT })
        max_time = options.delete(:max_time)
        listen
        begin
          client = sync_with_client(max_time)
          # write command to client
          req = options.merge({'command' => name})
          client.puts req.to_json
          close_client(client)
          client = nil
          client = wait_client(max_time)
          # wait response from client
          res = JSON.parse(client.readline.chomp)
          if res.nil? or res.has_key?('error')
            raise Exception::UIAutomationSlaveInvalidResponse.new(res['error']) 
          end
          res
        rescue Errno::ECONNRESET
          close_client(client)
          sleep 0.1
          retry
        rescue Errno::EPIPE
          close_client(client)
          sleep 0.1
          retry
        ensure
          close_client(client)
        end
      end

      def address
        listen
        @server.local_address.ip_address
      end

      def port
        listen
        @server.local_address.ip_port
      end

      def close
        unless @server.nil?
          @server.close rescue ::Exception
          @server = nil
        end
        unless @client_mutex.nil?
          @client_mutex.synchronize do
            @client_finished.signal
          end
        end
        unless @thread.nil?
          @thread.join
          @thread = nil
        end
      end

      private
      def listen
        return unless @server.nil?
        # create server
        @server = TCPServer.new(DEFAULT_HOSTNAME, DEFAULT_PORT)
        # create a thread for dealing with clients
        @thread = Thread.start do
          begin
            # keep accepting clients
            loop do
              break if @server.nil?
              # new client
              client = @server.accept
              @client_mutex.synchronize do
                @client = client
                # inform others we got a client.
                @client_acquired.signal
                # wait for reply saying we don't need the client anymore
                @client_finished.wait(@client_mutex)
              end
            end
          rescue Errno::EBADF
          end
        end
      end

      def wait_client(max_time)
        client = nil
        @client_mutex.synchronize do
          if @client.nil?
            @client_acquired.wait(@client_mutex, max_time)
          end
          client = @client
        end
        raise Exception::UIAutomationSlaveTimeout.new if client.nil?
        client
      end

      def close_client(client)
        @client_mutex.synchronize do
          if !client.nil? and client == @client
            @client = nil
            client.close rescue ::Exception
            @client_finished.signal
          end
        end
      end

      def sync_with_client(max_time)
        # wait for client
        client = wait_client(max_time)
        begin
          # expect client ack
          JSON.parse(client.readline.chomp).tap do |ack|
            break unless ack != {}
            # try to synchronize once again
            close_client(client)
            client = nil
            client = wait_client(max_time)
            JSON.parse(client.readline.chomp).tap do |ack|
              raise Exception::UIAutomationSlaveInvalidAck.new if ack != {}
            end
          end
        rescue ::Exception => err
          client_close(client)
          raise err
        end
        client
      end
    end
  end
end
