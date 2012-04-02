module Cukunity
  module TouchInputMethods
    include Cukunity::Utils

    DEFAULT_TAP_DELAY = 0.5

    def default_tap_delay=(delay)
      @default_tap_delay = delay.to_f
    end

    def set_default_tap_delay(delay)
      default_tap_delay = delay
    end

    def default_tap_delay
      @default_tap_delay || DEFAULT_TAP_DELAY
    end
  end
end
