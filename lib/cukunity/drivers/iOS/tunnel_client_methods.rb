module Cukunity
  module IOS
    module TunnelClientMethods
      include Cukunity::IOS::Utils

      def open_tunnel(lport, rport)
        return @tunnel if lport == 0 and !@tunnel.nil?
        # create tunnel to device
        @mobiledevice_pipe = mobile_device_cmd(['tunnel', lport.to_s, rport.to_s, :err => [:child, :out]], :wait => false)
        output = @mobiledevice_pipe.readline
        match = output.match(/^Tunneling from local port (\d+) to device port/)
        raise Exception::TunnelError.new(output) if match.nil?
        lport = match[1].to_i
        @tunnel = [lport, rport]
      end

      def close_tunnel
        @tunnel = nil
        unless @mobiledevice_pipe.nil?
          ::Process.kill('KILL', @mobiledevice_pipe.pid) rescue ::Exception
          @mobiledevice_pipe.close rescue ::Exception
          @mobiledevice_pipe = nil
        end
      end
    end
  end
end
