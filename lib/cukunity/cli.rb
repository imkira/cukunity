require 'rubygems'
require 'term/ansicolor'
class String
  include Term::ANSIColor
end
require 'cukunity/cli/main'
require 'cukunity/cli/options'
require 'cukunity/cli/argument_parser'
require 'cukunity/cli/doctor_command'
require 'cukunity/cli/bootstrap_command'
require 'cukunity/cli/features_command'
