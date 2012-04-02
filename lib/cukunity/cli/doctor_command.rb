require 'rbconfig'

module Cukunity
  module CLI
    class DoctorCommand
      def initialize(parser)
        @parser = parser 
      end

      def execute
        check_ruby
        check_cucumber
        check_ios if @parser.options.ios
        check_android if @parser.options.android
      end

      private
      def check_platform(platform)
        puts '==>'.blue + " Checking #{platform}"
      end

      def check_ok(item, path)
        puts '===>'.blue + " #{item} (#{path.green})"
      end

      def check_error(item, path, solution)
        $stdout.puts '===>'.red + " #{item} (#{path.red})"
        solution.each_line do |line|
          $stdout.puts '::::: '.red + " #{line}" 
        end
      end

      def check_ruby
        check_platform('Ruby')
        ruby = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name']).sub(/.*\s.*/m, '"\&"')
        if RbConfig::CONFIG['MAJOR'].to_i < 1 or RbConfig::CONFIG['MAJOR'].to_i <= 1 and
          RbConfig::CONFIG['MINOR'].to_i < 9
          solution = <<-eos

            Please install Ruby 1.9.x or above using RVM by following the instructions
            at http://beginrescueend.com .

          eos

          check_error(ruby, 'Ruby 1.8.x and below is not supported.', solution.gsub(/^ +/, ''))
        else
          check_ok('Ruby', ruby)
        end
      end

      def check_cucumber
        check_platform('Cucumber')

        check_file 'cucumber', <<-eos

          Please install cucumber gem from a terminal by executing:

          # gem install cucumber

          or, if you use bundler, just add the following to your Gemfile:
          
          gem 'cucumber'

          eos
      end

      def check_ios
        check_platform('iOS')

        check_file 'mobiledevice', <<-eos

          Please install "mobiledevice" from http://github.com/imkira/mobiledevice
          from a terminal by executing:

          # git clone git://github.com/imkira/mobiledevice.git
          # cd mobiledevice
          # rake install

          eos

        check_file 'instruments', <<-eos

          Please install XCode 4.2 or above from https://developer.apple.com/xcode/ .

          eos

        check_file ['/Developer/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate', '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate'], <<-eos

          Please install XCode 4.2 or above from https://developer.apple.com/xcode/ .
          Also, make sure you have iOS 5 SDK installed.

          eos
      end

      def check_android
        check_platform('Android')

        check_file 'android', <<-eos

          Please install the "Android SDK" from http://developer.android.com/sdk/ .

          If you use "brew" ( http://mxcl.github.com/homebrew/ ), you can install it with:
          # brew install android-sdk

          eos

        ['adb', 'aapt'].each do |tool|
          check_file tool, <<-eos

            Please install the "Android SDK tools" from the "Android SDK Manager".

            You can launch the manager from a terminal by executing:
            # android

            Within the manager, you can install the "Android SDK Tools" package from Google.

            After installation, make sure "platform-tools" folder is in your PATH environment.

            eos
        end
      end

      def check_file(items, solution)
        items = [items] unless items.is_a? Array
        items.each do |item|
          full_path = env_path(item)
          full_path = File.expand_path(item) unless full_path
          if full_path and File.exists?(full_path)
            if File.file?(full_path)
              check_ok(item, full_path)
              return
            end
            check_error(item, 'Found expecting a file', solution.gsub(/^ +/, ''))
          else
          end
        end
        check_error(items.join(' , '), 'Not found', solution.gsub(/^ +/, ''))
      end

      def env_path(path)
        ENV['PATH'].split(':').each do |dir|
          if File.exists?(File.join(dir, path))
            return File.expand_path(File.join(dir, path))
          end
        end
        nil
      end
    end
  end
end
