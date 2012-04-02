module Cukunity
  module Unity
    class Component < Unity::JSONContainer
      attr_reader :gameobject

      def initialize(json, gameobject)
        super(json)
        @gameobject = gameobject 
      end

      def hint(*args)
        hints(*args).first
      end

      def has_hint?(*args)
        !hint(*args).nil?
      end

      def hints(options = {})
        # memoize all hints
        if @hints.nil?
          @hints = (value_of('.hints') || []).inject([]) do |hints, json|
            type = json[0]
            values = json[1]
            hints + values.map do |json|
              Unity::Hint.new(json, type, self)
            end
          end
        end
        options = merge_options(options, { :type => nil })
        return @hints if options[:type].nil?
        # select desired hints
        @hints.select do |hint|
          options[:type].to_s == hint.type
        end
      end
    end
  end
end
