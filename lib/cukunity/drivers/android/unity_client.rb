module Cukunity
  module Android
    module Unity
      class Client
        include Cukunity::Android::TunnelClientMethods
        include Cukunity::Unity::ClientMethods
        alias_method :client_connect_original, :connect
        alias_method :client_close_original, :close

        def platform
          Cukunity::Android
        end

        def close
          client_close_original
          close_tunnel
        end

        private
        def connect(host = DEFAULT_HOSTNAME, port = DEFAULT_PORT)
          open_tunnel(port + 1, port)
          client_connect_original(host, port + 1)
        end
      end
    end
  end
end
