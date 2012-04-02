require 'tmpdir'

module Cukunity
  module IOS
    module Process
      extend IOS::Utils
      extend Cukunity::Utils

      def self.launch(path, max_time = 30)
        unless App::installed?(path)
          App::install(path)
        end
        pipe = Cukunity::IOS::UIAutomation.instance.popen(bundle_identifier(path))
        raise Exception::LaunchTimeout.new if max_time > 0 and check_timeout(max_time) do
          foreground?(path)
        end
      end

      def self.foreground?(path)
        running?(path)
      end

      def self.running?(path)
        path_bundle_id = bundle_identifier(path)
        begin
          # it should be already running and polling
          res = uiautomation_cmd('bundleIdentifier', :max_time => 3)
          res['bundleIdentifier'] == path_bundle_id
        rescue Exception::UIAutomationSlaveTimeout
          false
        end
      end

      def self.relaunch(path, max_time = 30)
        Cukunity::IOS::Unity::Client.instance.close
        Cukunity::IOS::UIAutomationMaster.instance.close
        Cukunity::IOS::UIAutomation.instance.close
        launch(path, max_time)
      end
    end
  end
end
