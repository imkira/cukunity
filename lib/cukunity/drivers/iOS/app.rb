module Cukunity
  module IOS 
    module App
      extend IOS::Utils
      extend Cukunity::Utils

      def self.install(path, options = {})
        options = merge_options(options, { :max_time => 30 })
        output = mobile_device_cmd(['install_app', path], options).first.chomp
        raise Exception::InstallFailed.new unless output == 'OK'
      end

      def self.uninstall(path, options = {})
        options = merge_options(options, { :max_time => 30 })
        bundle_id = bundle_identifier(path)
        output = mobile_device_cmd(['uninstall_app', bundle_id], options).first.chomp
        raise Exception::UninstallFailed.new unless output == 'OK'
      end

      def self.installed
        mobile_device_cmd(['list_installed_apps']).map do |bundle_id|
          bundle_id.chomp
        end
      end

      def self.installed?(path)
        bundle_id = bundle_identifier(path)
        installed.include?(bundle_id)
      end
    end
  end
end
