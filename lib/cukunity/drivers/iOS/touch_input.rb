module Cukunity
  module IOS
    module TouchInput
      extend IOS::Utils
      extend Cukunity::TouchInputMethods

      def self.touch_screen(options)
        options = merge_options(options, { :x => 0, :y => 0, :method => 'tap', :tapCount => 1 })
        wait = (options.delete(:wait) || self.default_tap_delay).to_f
        # FIXME: screen dimensions
        options[:x] = options[:x].to_i / 2
        options[:y] = options[:y].to_i / 2
        unity_command('touch_screen', restrict_options(options, :x, :y, :method, :tapCount))
        sleep(wait) unless wait.nil? or wait <= 0
      end
    end
  end
end
