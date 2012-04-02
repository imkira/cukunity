require 'socket'

module Cukunity
  module RequestLineResponseClientMethods
    include Cukunity::Utils

    DEFAULT_TIMEOUT = 30

    def request(line, options = {})
      options = merge_options(options, { :max_time => DEFAULT_TIMEOUT,
                                         :quit => false, :retry => true })
      connect
      response = nil
      begin
        raise Exception::MobileDeviceTimeout.new(cmd) if check_timeout(options[:max_time]) do
          @socket.puts(line)
          @socket.flush
          return if options[:quit]
          response = @socket.gets
          break unless response.nil? and options[:retry]
          close
          sleep 0.1
          connect
          false
        end
      rescue Errno::ECONNRESET
        return if options[:quit]
        close
        if options[:retry]
          connect
          retry
        end
      rescue Errno::EPIPE
        return if options[:quit]
        close
        if options[:retry]
          connect
          retry
        end
      end
      if block_given?
        yield response
      else
        response
      end
    end

    private
    def connect(host, port, max_time = DEFAULT_TIMEOUT)
      return unless @socket.nil? or @socket.closed?
      raise Exception::ConnectionTimeout.new if check_timeout(max_time) do
        # new connection to server
        @socket = TCPSocket.new(host, port)
        # get ACK from server
        if block_given?
          begin
            yield @socket
          rescue
            # close and retry
            @socket.close rescue ::Exception
            @socket = nil
          end
        else
          true
        end
      end
    end

    def connected?
      !@socket.nil?
    end

    def close
      unless @socket.nil?
        @socket.close rescue ::Exception
        @socket = nil
      end
    end
  end
end
