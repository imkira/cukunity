module Cukunity
  module Android
    module App
      extend Android::Utils
      extend Cukunity::Utils

      def self.install(path, options = {})
        options = merge_options(options, { :max_time => 30 })
        output, status = adb ['install', '-r', path]
        unless status.exited? and status.exitstatus == 0
          raise Exception::InstallFailed.new
        end
        raise Exception::InstallTimeout.new if check_timeout(options[:max_time]) do
          installed?(path)
        end
      end

      def self.uninstall(path, options = {})
        options = merge_options(options, { :max_time => 30 })
        output, status = adb ['uninstall', package_name(path)]
        unless status.exited? and status.exitstatus == 0
          raise Exception::UninstallFailed.new
        end
        raise Exception::UninstallTimeout.new if check_timeout(options[:max_time]) do
          not installed?(path)
        end
      end

      def self.installed
        shell('pm list packages').scan(/^package:(\S+)/).inject([]) do |packages, m|
          packages << m[0]
        end
      end

      def self.installed?(path)
        package = package_name(path).downcase
        installed.any? do |p|
          p.downcase == package 
        end
      end
    end
  end
end
