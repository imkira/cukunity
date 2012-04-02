module Cukunity
  module IOS
    module KeyboardInput
      extend IOS::Utils
      extend Cukunity::KeyboardInputMethods

      def self.typed_text(options = {})
        res = keyboard_command(options) do
          'typedText'
        end
        res['text']
      end

      def self.type_text(text, options = {})
        keyboard_command(options) do
          ['typeText', { 'text' => text.to_s }]
        end
      end

      def self.clear_text(options = {})
        keyboard_command(options) do
          'clearText'
        end
      end

      def self.press_key(code, options = {})
        keyboard_command(options) do
          ['tapKeyboardKey', { 'key' => code }]
        end
      end

      def self.press_button(code, options = {})
        keyboard_command(options) do
          ['tapKeyboardButton', { 'button' => code }]
        end
      end

      def self.press_toolbar_button(code, options = {})
        keyboard_command(options) do
          ['tapKeyboardToolbarButton', { 'button' => code }]
        end
      end

      def self.keyboard_buttons(options = {})
        keyboard_command(options) do
          'keyboardButtons'
        end
      end

      def self.keyboard_keys(options = {})
        keyboard_command(options) do
          'keyboardKeys'
        end
      end

      def self.press_done(options = {})
        press_toolbar_button('Done', options)
      end

      def self.press_back(options = {})
        press_done(options)
      end

      def self.press_enter(options = {})
        press_button('return', options)
      end

      def self.press_space(options = {})
        press_key('space', options)
      end

      def self.press_delete(options = {})
        press_button('Delete', options)
      end

      private
      def self.closed?(options = {})
        res = keyboard_command(options) do
          'isKeyboardAvailable'
        end
        res['available'] != true
      end

      def self.platform_open_keyboard(options = {})
        raise Exception::KeyboardWaitTimeout.new if check_timeout(10) do
          !closed?(options)
        end
        if options[:clear]
          clear_text
        end
      end

      def self.platform_keyboard_command(options, *cmd)
        uiautomation_cmd(*cmd)
      end

      def self.toolbar_buttons(options = {})
        keyboard_command(options) do
          'keyboardToolbarButtons'
        end
      end
    end
  end
end
