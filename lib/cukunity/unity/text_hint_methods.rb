module Cukunity
  module Unity
    module TextHintMethods
      def text
        json
      end

      def reads_as?(text)
        text.to_s == self.text 
      end

      def reads_like?(regexp)
        !text.match(regexp).nil?
      end
    end
  end
end
