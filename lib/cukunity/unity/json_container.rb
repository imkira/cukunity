module Cukunity
  module Unity
    class JSONContainer
      include Cukunity::Utils
      attr_reader :json

      def initialize(json)
        @json = json
      end

      def value_of(key)
        @json[key.to_s]
      end

      alias_method :[], :value_of
      alias_method :property, :value_of

      def keys
        @json.keys
      end

      alias_method :properties, :keys

      def has_key?(key)
        @json.has_key?(key.to_s)
      end

      alias_method :has_property?, :has_key?

      # inspect json structure dynamically
      def method_missing(meth, *args, &block)
        if json.is_a? Hash
          meth = meth.to_s
          return property(meth) if has_property?(meth)
          if meth[-1..-1] == '?'
            meth = meth[0...-1]
            return !!property(meth) if has_property?(meth)
          end
        end
        super
      end

      def to_s
        @json.to_s
      end
    end
  end
end
