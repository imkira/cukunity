module Cukunity
  module Unity
    class Screen < Unity::JSONContainer
      attr_reader :client

      def initialize(client, *args)
        @client = client
        super(*args)
      end

      def tap(pos, options = {})
        options = invert_y(pos, options)
        options[:type] = :tap
        client.platform::TouchInput.touch_screen(options)
      end

      def touch_down(pos, options = {})
        options = invert_y(pos, options)
        options[:down] = :down
        client.platform::TouchInput.touch_screen(options)
      end

      def touch_release(pos, options = {})
        options = invert_y(pos, options)
        options[:up] = :up
        client.platform::TouchInput.touch_screen(options)
      end

      def touch_move(pos, options = {})
        options = invert_y(pos, options)
        options[:move] = :move
        client.platform::TouchInput.touch_screen(options)
      end

      alias_method :touch_up, :touch_release

      private
      def invert_y(pos, options)
        merge_options(pos, options).tap do |options|
          options[:y] = value_of('height') - options[:y]
        end
      end
    end
  end
end
