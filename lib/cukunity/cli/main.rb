module Cukunity
  module CLI
    class Main
      def self.execute!(args = ARGV)
        new(args).execute
      end

      def initialize(args)
        @args = args.dup
      end

      def execute
        command = Cukunity::CLI::ArgumentParser.parse(@args)
        command.execute unless command.nil?
      end
    end
  end
end
