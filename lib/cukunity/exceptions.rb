module Cukunity 
  module Exception
    class UnspecifiedPlatform < ::Exception; end
    class InvalidApp < ::Exception; end
    class LaunchTimeout < ::Exception; end
    class InstallFailed < ::Exception; end
    class UninstallFailed < ::Exception; end
    class InstallTimeout < ::Exception; end
    class UninstallTimeout < ::Exception; end
    class TunnelError < ::Exception; end
    class ConnectionTimeout < ::Exception; end
    class MonkeyInvalidAck < ::Exception; end
    class MonkeyCommandError < ::Exception; end
    class MonkeyConnectTimeout < ::Exception; end
    class MobileDeviceError < ::Exception; end
    class MobileDeviceTimeout < ::Exception; end
    class UIAutomationSlaveTimeout < ::Exception; end
    class UIAutomationSlaveInvalidAck < ::Exception; end
    class UIAutomationSlaveInvalidResponse < ::Exception; end
    class KeyboardWaitTimeout < ::Exception; end
    class UnityInvalidAck < ::Exception; end
    class UnityCommandError < ::Exception; end
  end
end
