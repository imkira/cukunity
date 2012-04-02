module Cukunity
  module Android
    module Utils
      include Cukunity::Utils

      def monkey
        Android::MonkeyClient.instance
      end

      def shell(cmd_line)
        `adb -d shell #{cmd_line}`
      end

      def adb(cmd, options = {})
        options = merge_options(options, { :wait => true })
        cmd_line = ['adb', '-d'] + cmd + [:err => [:child, :out]]
        return IO.popen(cmd_line) if !options[:wait]
        output = IO.popen(cmd_line) do |io|
          if block_given?
            yield io
          else
            io.readlines
          end
        end
        [output, $?]
      end

      def launchable_activity_name(path)
        return path unless File.exists?(path)
        dump_badging(path).match(/launchable-activity:.*name='(.[^']+)'/) do |m|
          return m[1]
        end
        raise Exception::InvalidApp.new(path)
      end

      def package_name(path)
        return path unless File.exists?(path)
        dump_badging(path).match(/package:.*name='(.[^']+)'/) do |m|
          return m[1]
        end
        throw InvalidApp.new(path)
      end

      private
      def dump_badging(path)
        `aapt dump badging "#{path}"`
      end
    end
  end
end
