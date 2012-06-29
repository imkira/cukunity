require 'optparse'

module Cukunity
  module CLI
    class ArgumentParser
      attr_reader :args
      attr_reader :remaining_args
      attr_reader :cucumber_args
      attr_reader :options
      attr_reader :command

      def self.parse(args)
        parser = new(args)
        parser.parse
      end

      def initialize(args)
        @args = args.dup
      end

      def parse
        parse_options
        parse_command
      end

      private
      def abort_with_msg(msg)
        abort ["Error: #{msg}", @parser].join("\n\n")
      end

      def parse_options
        # default options
        defaults =
        {
          :verbose => true,
          :ios => true,
          :android => true,
          :help => false
        }
        options = Cukunity::CLI::Options.new(defaults)

        @remaining_args = @args.take_while {|arg| arg != '--' }
        @cucumber_args  = @args.drop_while {|arg| arg != '--' }
        @cucumber_args  = @cucumber_args.drop(1) unless @cucumber_args.empty?

        @parser = ::OptionParser.new do |opts|
          opts.banner = 'Usage: cukunity [options] <command>'

          opts.separator ''
          opts.separator 'Commands:'
          opts.separator 'doctor              Check your system for the required platform tools.'
          opts.separator 'bootstrap <path>    Bootstrap your Unity project.'
          opts.separator 'features [<path>]   Run cucumber against path containing feature files.'

          opts.separator ''
          opts.separator 'Options:'

          # --verbose
          opts.on('-v', '--[no-]verbose', 'Enable/Disable verbose mode.') do |v|
            options.verbose = v
          end

          # --android
          opts.on('--[no-]android', 'Enable/Disable for Android development.') do |use|
            options.android = use
          end

          # --ios
          opts.on('--[no-]ios', 'Enable/Disable for Android development.') do |use|
            options.ios = use
          end

          # --help
          opts.on('-h', '--help', 'This help screen.') do
            options.help = true
          end
        end
        
        begin
          # parse and return options
          @parser.parse!(@remaining_args)
        rescue ::OptionParser::ParseError => err
          abort_with_msg err
        end
        @options = options
      end

      def parse_command
        @command = @remaining_args.shift
        if options.help or @command.nil?
          puts @parser
          return nil
        end
        case @command.downcase
        when 'doctor'
          Cukunity::CLI::DoctorCommand.new(self)
        when 'bootstrap'
          Cukunity::CLI::BootstrapCommand.new(self)
        when 'features'
          Cukunity::CLI::FeaturesCommand.new(self)
        else
          abort_with_msg %Q[Error: Command "#{@command}" is unknown.]
        end
      end
    end
  end
end
