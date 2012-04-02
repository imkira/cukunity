# -*- coding: UTF-8 -*-

require 'cucumber'
require 'rspec/core'
require 'rspec/expectations'

require 'cukunity'

cucumber_dir = File.join(File.dirname(__FILE__), 'cucumber')

# helpers
Dir.glob(File.join(cucumber_dir, 'support', '**', '*.rb')) do |f|
  require f
end

# step_definitions
Dir.glob(File.join(cucumber_dir, 'step_definitions', '**', '*.rb')) do |f|
  require f
end

at_exit do
  # close connections, close pipes, remove temporary files, etc.
  Cukunity::Android::Unity::Client.instance.close
  Cukunity::Android::MonkeyClient.instance.close
  Cukunity::IOS::Unity::Client.instance.close
  Cukunity::IOS::UIAutomationMaster.instance.close
  Cukunity::IOS::UIAutomation.instance.close
end
