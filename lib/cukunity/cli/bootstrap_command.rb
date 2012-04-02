require 'fileutils'
require 'pathname'

module Cukunity
  module CLI
    class BootstrapCommand 
      def initialize(parser)
        @parser = parser 
      end

      def execute
        path = @parser.remaining_args.first
        if path.nil?
          abort 'You should specify the path to the base of your Unity project.'
        end
        bootstrap_unity(File.expand_path(path))
      end

      private
      def bootstrap_unity(path)
        dst_assets = File.join(path, 'Assets')
        unless File.directory?(dst_assets)
          abort %Q[Invalid Unity project base specified. Please make sure "#{path}" contains the "Assets" directory.]
        end
        src_assets = File.expand_path(File.join(File.dirname(__FILE__), '../../../Unity/Assets'))
        Dir.glob("#{src_assets}/Plugins/**/*") do |file|
          next if File.directory?(file) or File.extname(file) == '.meta'
          relative_path = Pathname.new(file).relative_path_from(Pathname.new(src_assets)).to_s
          dst_path = File.join(dst_assets, relative_path)
          FileUtils.mkdir_p(File.dirname(dst_path))
          if @parser.options.verbose
            $stdout.puts '===>'.blue + " Copying #{file} " + 'to'.blue + " #{dst_path}"
          end
          FileUtils.copy(file, dst_path)
        end
      end
    end
  end
end
