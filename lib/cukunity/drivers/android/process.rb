module Cukunity
  module Android
    module Process
      extend Android::Utils
      extend Cukunity::Utils

      def self.launch(path, extras = {}, max_time = 30)
        unless App::installed?(path)
          App::install(path)
        end
        package = package_name(path)
        activity = launchable_activity_name(path)
        extras_args = extras.inject([]) do |extras, kvp|
          key, value = kvp
          type = 
            if value.kind_of? String
              '--es'
            elsif value.kind_of? Fixnum
              '--ei'
            elsif value === true or value === false
              '--ez'
            else
              raise ArgumentError.new("Unsupported type #{value.class} as extra parameter to activity")
            end
          extras.push %Q[#{type} "#{key}" "#{value}"]
        end.join(" ")
        shell %Q[am start #{extras_args} -n "#{package}/#{activity}" -W]
        raise Exception::LaunchTimeout.new if max_time > 0 and check_timeout(max_time) do
          foreground?(path)
        end
      end

      def self.running
        headers = /^\S+\s+(\d+)\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S.*)/
        shell('ps').scan(headers).inject({}) do |packages, m|
          packages[m[0].to_i] = m[1].chomp
          packages
        end
      end

      def self.foreground
        shell('dumpsys activity').match(/TaskRecord\{[^\n\}]+\s+([^\s\}]+)}/) do |m|
          return m[1]
        end
      end

      def self.foreground?(path)
        fg = foreground
        if fg
          fg.downcase  == package_name(path).downcase
        else
          false
        end
      end

      def self.running?(path)
        package = package_name(path).downcase
        running.any? do |pid, p|
          p.downcase == package 
        end
      end

      def self.pids(path)
        package = package_name(path).downcase
        running.select do |pid, p|
          p.downcase == package 
        end.keys
      end

      def self.relaunch(path, max_time = 30)
        unless App::installed?(path)
          App::install(path)
        end
        before_pids = pids(path)
        unless before_pids.empty?
          # launch restarter
          _relaunch(path)
          raise Exception::LaunchTimeout.new if check_timeout(max_time) do
            now_pids = pids(path)
            before_pids.all? do |pid|
              # old process does not exist?
              not now_pids.include?(pid)
            end
          end
        end
        # wait for a new app
        start = Time.now
        raise Exception::LaunchTimeout.new if check_timeout(max_time) do
          foreground?(path)
        end
      end

      private
      def self._relaunch(path)
        app_killer = File.join(File.expand_path(File.dirname(__FILE__)), 'appkiller', 'bin', 'AppKiller.apk')
        unless App::installed?(app_killer)
          App::install(app_killer)
        end
        launch(app_killer, {'package' => package_name(path)}, 0)
      end
    end
  end
end
