module Cukunity
  module KeyboardInputMethods
    include Cukunity::Utils

    def open(options = {})
      options = merge_options(options, { :clear => false, :close => true })
      platform_open_keyboard(restrict_options(options, :clear))
      yield self
      if options[:close]
        close_keyboard
      end
    end

    private
    def keyboard_command(options)
      options = to_options(options)
      wait = (options.delete(:wait) || 0.5).to_f
      cmd = yield
      res = platform_keyboard_command(options, *cmd)
      sleep(wait) unless wait.nil? or wait <= 0
      res
    end

    def close_keyboard(options = {})
      raise Exception::KeyboardWaitTimeout.new if check_timeout(10) do
        if closed?
          true
        else
          press_back
          false
        end
      end
    end
  end
end
