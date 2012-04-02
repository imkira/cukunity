module Cukunity
  module IOS
    module Utils
      include Cukunity::Utils

      MOBILE_DEVICE_DEFAULT_TIMEOUT = 60

      def unity_command(name, opts = {})
        Cukunity::IOS::Unity::Client.instance.command(name, opts)
      end

      def mobile_device_cmd(cmd, options = {})
        options = merge_options(options, { :wait => true, :max_time => MOBILE_DEVICE_DEFAULT_TIMEOUT })
        pipe = IO.popen(['mobiledevice'] + cmd)
        return pipe unless options[:wait]
        status = nil
        raise Exception::MobileDeviceTimeout.new(cmd) if check_timeout(options[:max_time]) do
          if ::Process.waitpid(pipe.pid, ::Process::WNOHANG)
            status = $?
            true
          else
            false
          end
        end
        output = pipe.readlines
        pipe.close
        raise Exception::MobileDeviceError.new(cmd) unless status.exitstatus == 0
        output
      end

      def device_udid
        udid = mobile_device_cmd(['get_udid']).first.chomp
        raise Exception::MobileDeviceError.new(udid) unless udid.length == 40
        udid
      end

      def bundle_identifier(app_folder)
        mobile_device_cmd(['get_bundle_id', app_folder]).first.chomp
      end

      def uiautomation_cmd(name, options = {})
        Cukunity::IOS::UIAutomationMaster.instance.command(name, options)
      end
    end
  end
end
