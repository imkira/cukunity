module Cukunity
  module Unity
    class Hint < Unity::JSONContainer
      include ScreenHintMethods
      include TextHintMethods

      attr_reader :component
      attr_reader :type
      attr_reader :value

      def initialize(json, type, component)
        super(json)
        @type = type
        @value = json
        @component = component 
      end

      def gameobject
        component.gameobject
      end

      def to_s
        { type.to_s => json }.to_s
      end
    end
  end
end
