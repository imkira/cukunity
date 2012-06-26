require 'fileutils'
require 'pathname'

module Cukunity
  module CLI
    class FeaturesCommand 
      def initialize(parser)
        @parser = parser 
      end

      def execute
        path = @parser.options.path
        if @parser.options.ios
          if @parser.options.android
            abort 'You cannot test both iOS and Android simultaneously. ' \
              'Please disable one of the platforms by using ' \
              '--no-ios or --no-android'
          end
          platform_flags = '~@android,@ios'
        elsif @parser.options.android
          platform_flags = '~@ios,@android'
        else
          abort 'You should specify which platform you want to test by specifying ' \
            'either --ios or --android'
        end
        cukunity = File.expand_path(File.join(File.dirname(__FILE__), '..', 'cucumber.rb'))

        cucumber_args = ['--require', cukunity, '--require', path, '--format', 'pretty', '-t', platform_flags]
        cucumber_args += @parser.remaining_args
        system 'cucumber', *cucumber_args
      end
    end
  end
end
