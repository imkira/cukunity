module Cukunity
  module Unity
    class GameObject < Unity::JSONContainer
      attr_reader :scene
      attr_reader :parent

      def initialize(json, scene, parent = nil)
        super(json)
        @scene = scene
        @parent = parent
      end

      def children
        @children ||= (value_of('children') || []).map do |json|
          Unity::GameObject.new(json, @scene, self)
        end
      end

      def component(*args)
        components(*args).first
      end

      def has_component?(*args)
        !!component(*args)
      end

      def components(options = {})
        # memoize all components
        if @components.nil?
          @components = (value_of('components') || []).map do |json|
            Unity::Component.new(json, self)
          end
          @components += children.inject([]) do |components, child|
            components + child.components(:recursive => true)
          end
        end
        options = merge_options(options, { :recursive => false })
        # select desired components
        @components.select do |component|
          acceptable_type = (options[:type].nil? or options[:type] == component.type)
          acceptable_type and (options[:recursive] or component.gameobject == self)
        end
      end

      def hints(options = {})
        options = merge_options(options, { :recursive => false })
        components(restrict_options(options, :recursive)).inject([]) do |hints, component|
          hints + component.hints(options)
        end
      end
    end
  end
end
