module Cukunity
  module Android
    module TouchInput
      extend Android::Utils
      extend Cukunity::TouchInputMethods

      def self.touch_screen(options)
        options = merge_options(options, { :x => 0, :y => 0, :type => :tap })
        wait = (options.delete(:wait) || 0.1).to_f
        options[:x] = options[:x].to_i
        options[:y] = options[:y].to_i
        prefix = 
          if options[:type] == :tap
            "tap"
          else
            "touch #{type}"
          end
        req = %Q[#{prefix} #{options[:x]} #{options[:y]}]
        monkey.command(req)
        sleep(wait) unless wait.nil? or wait <= 0
      end
    end
  end
end
