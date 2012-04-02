module Cukunity
  module IOS
    module Unity
      class Client
        include Cukunity::IOS::TunnelClientMethods
        include Cukunity::Unity::ClientMethods
        alias_method :client_connect_original, :connect
        alias_method :client_close_original, :close

        def platform
          Cukunity::IOS
        end

        def close
          client_close_original
          close_tunnel
        end

        private
        def connect(host = DEFAULT_HOSTNAME, port = DEFAULT_PORT)
          lport, rport = open_tunnel(0, port)
          client_connect_original(host, lport)
        end
      end
    end
  end
end
