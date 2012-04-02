module Cukunity
  module Android
    module KeyboardInput
      extend Android::Utils
      extend Cukunity::KeyboardInputMethods

      def self.type_text(text, options = {})
        text.to_s.scan(/[^ ]+| /) do |tokens|
          if tokens == ' '
            press_space
          else
            keyboard_command(options) do
              %Q[type #{tokens}]
            end
          end
        end
      end

      def self.press_key(code, options = {})
        keyboard_command(options) do
          "press #{keycode(code)}"
        end
      end

      def self.key_down(code, options = {})
        keyboard_command(options) do
          "key down #{keycode(code)}"
        end
      end

      def self.key_up(code, options = {})
        keyboard_command(options) do
          "key up #{keycode(code)}"
        end
      end

      def self.press_done(options = {})
        press_back(options)
      end

      def self.press_back(options = {})
        press_key('Back', options)
      end

      def self.press_enter(options = {})
        press_key('Enter', options)
      end

      def self.press_space(options = {})
        press_key('Space', options)
      end

      def self.press_delete(options = {})
        press_key('Del', options)
      end

      def self.dpad_up(options = {})
        press_key('DPad Up', options)
      end

      def self.dpad_down(options = {})
        press_key('DPad Down', options)
      end

      def self.dpad_left(options = {})
        press_key('DPad Left', options)
      end

      def self.dpad_right(options = {})
        press_key('DPad Right', options)
      end

      def self.dpad_center(options = {})
        press_key('DPad Center', options)
      end

      def self.show_symbols
        press_key('PictSymbols', options)
      end

      def self.methods
        shell('dumpsys input_method').scan(/\smId=(\S+)\s/).flatten
      end

      def self.method
        shell('dumpsys input_method').match(/\smCurId=(\S+)\s/) do |m|
          return m[1]
        end
        nil
      end

      def self.method?(method2)
        if method2.kind_of? Regexp
          method.match(method2)
        else
          method.downcase == method2.downcase
        end
      end

      def self.choose_method(method2, options = {})
        while not method?(method2)
          press_key('Sym', options)
          dpad_down(options)
          dpad_center(options)
        end
      end

      private
      def self.closed?
        shell('dumpsys input_method').match(/\sfieldId=\d+\s/).nil?
      end

      def self.platform_open_keyboard(options = {})
        raise Exception::KeyboardWaitTimeout.new if check_timeout(10) do
          !closed?
        end
        if options[:clear]
          press_delete options
        else
          dpad_right
        end
        choose_method(options[:method], options) unless options[:method].nil?
      end

      def self.platform_keyboard_command(options, *cmd)
        monkey.command(*cmd)
      end

      # http://developer.android.com/reference/android/view/KeyEvent.html
      def self.keycode(code)
        code = code.to_s.strip
        if code =~ /^\d+$/
          code.to_i
        else
          code = code.gsub(/\s+/, '_').upcase
          if code !~ /^KEYCODE_/
            code = "KEYCODE_#{code}"
          end
          code = code.to_sym
          if Cukunity::Android::KeyboardInput::KeyCodes.const_defined?(code)
            Cukunity::Android::KeyboardInput::KeyCodes.const_get(code).to_i
          else
            raise ArgumentError.new("Keycode unknown for \"#{code}\"")
          end
        end
      end
    end
  end
end
