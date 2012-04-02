module Cukunity
  module Android
    module TunnelClientMethods
      include Cukunity::Android::Utils

      def open_tunnel(lport, rport)
        return @tunnel if @tunnel == [lport, rport]
        # create tunnel to device
        output, status = adb ['forward', "tcp:#{lport.to_i}", "tcp:#{rport.to_i}"]
        unless status.exited? and status.exitstatus == 0
          raise Exception::TunnelError.new
        end
        @tunnel = [lport, rport]
      end

      def close_tunnel
        # FIXME: remove tunnel
        @tunnel = nil
      end
    end
  end
end
