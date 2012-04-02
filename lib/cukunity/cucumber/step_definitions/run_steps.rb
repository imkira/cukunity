# -*- coding: UTF-8 -*-

Given /^I (re)?(?:launch|run) the app "([^"]*)"$/ do |relaunch, path|
  set_current_app(path)
  if not running?(current_app)
    launch(current_app)
  elsif relaunch
    relaunch(current_app)
  end
end

Given /^I (re)?launch it$/ do |relaunch|
  step %Q[I #{relaunch}launch the app "#{current_app}"]
end

Then /^the app "([^"]*)" should( not)? be running$/ do |path, negation|
  set_current_app(path)
  should negation, process, be_running(current_app)
end

Then /^it should( not)? be running$/ do |negation|
  step %Q[the app "#{current_app}" should#{negation} be running]
end

Then /^the app "([^"]*)" should( not)? be running on (?:foreground|screen)$/ do |path, negation|
  set_current_app(path)
  should negation, process, be_foreground(current_app)
end

Then /^it should( not)? be running on (?:foreground|screen)$/ do |negation|
  step %Q[the app "#{current_app}" should#{negation} be running on foreground]
end
