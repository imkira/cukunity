module Cukunity
  module Unity
    module ScreenHintMethods
      def screen_pos(options = {})
        options = merge_options(options, { :horizontal => :center, :vertical => :center })
        pos = {}
        case options[:horizontal]
        when :left
          pos[:x] = value_of('x').to_i
        when :right
          pos[:x] = (value_of('x') + value_of('width')).to_i
        else
          pos[:x] = (value_of('x') + value_of('width') / 2).to_i
        end
        case options[:vertical]
        when :bottom
          pos[:y] = value_of('y').to_i
        when :top
          pos[:y] = (value_of('y') + value_of('height')).to_i
        else
          pos[:y] = (value_of('y') + value_of('height') / 2).to_i
        end
        pos
      end

      def rect
        { :x => value_of('x'), :y => value_of('y'),
          :width => value_of('width'), :height => value_of('height') }
      end

      def on_screen?
        return false unless component.enabled? and gameobject.active?
        intersects?(gameobject.scene.client.screen.json)
      end

      def intersects?(arg)
        _rect2 =
          if arg.kind_of? Hash
            merge_options(arg, { :x => 0, :y => 0, :width => 0, :height => 0 })
          else
            arg.rect
          end
        _rect = self.rect
        # completely to the left?
        return false if (_rect[:x] + _rect[:width]) <= _rect2[:x] 
        # completely to the right?
        return false if _rect[:x] >= (_rect2[:x] + _rect2[:width])
        # completely above?
        return false if (_rect[:y] + _rect[:height]) <= _rect2[:y] 
        # completely below?
        return false if _rect[:y] >= (_rect2[:y] + _rect2[:height])
        # prove by contradiction
        true
      end

      def tap(options = {})
        gameobject.scene.client.screen.tap screen_pos(options), options
      end
    end
  end
end
