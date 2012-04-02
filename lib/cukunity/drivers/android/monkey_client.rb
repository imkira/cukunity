require 'singleton'

module Cukunity
  module Android
    class MonkeyClient
      include Singleton
      include Cukunity::Android::TunnelClientMethods
      include Cukunity::RequestLineResponseClientMethods
      alias_method :request_connect, :connect
      alias_method :request_close, :close

      DEFAULT_HOSTNAME = '127.0.0.1'
      DEFAULT_PORT = 9923

      def command(req)
        res = request(req.chomp) do |line|
          m = line.chomp.match(/^([^:]+)(:(.*))?$/)
          { :status => m[1], :output => m[2] || '' }
        end
        raise Exception::MonkeyCommandError.new(res[:output]) if res.nil? or res[:status] != 'OK'
        res[:output]
      end

      def close
        if connected?
          request 'quit', :quit => true, :retry => false rescue ::Exception
          request_close
        end
        close_tunnel
        unless @monkey_pipe.nil?
          ::Process.kill('KILL', @monkey_pipe.pid) rescue ::Exception
          @monkey_pipe.close rescue ::Exception
          @monkey_pipe = nil
        end
      end

      private
      def kick_monkey(host, port)
        if @monkey_pipe.nil?
          open_tunnel(port + 1, port)
          @monkey_pipe = adb ['shell', 'monkey', '--port', port.to_s], :wait => false
          # FIXME: investigate why this sleep is "necessary"
          sleep 1
          raise Exception::MonkeyCommandError.new unless wait_connectivity(host, port + 1, 30)
        end
      end

      def connect(host = DEFAULT_HOSTNAME, port = DEFAULT_PORT)
        unless @connecting
          @connecting = true
          kick_monkey(host, port)
          begin
            request_connect(host, port + 1) do |socket|
              kick_monkey(host, port)
              command('wake')
              true
            end
          ensure
            @connecting = false
          end
        end
      end
    end
  end
end
