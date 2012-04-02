# -*- coding: UTF-8 -*-

Given /^I (re)?install the (?:app|game)(?: from)? "([^"]*)"$/ do |reinstall, path|
  set_current_app(path)
  if not installed?(current_app)
    install(current_app)
  elsif reinstall
    uninstall(current_app)
    install(current_app)
  end
end

Given /^I (re)?install it$/ do |reinstall|
  step %Q[I #{reinstall}install the app "#{current_app}"]
end

Given /^I uninstall the (?:app|game) "([^"]*)"$/ do |path|
  set_current_app(path)
  uninstall(current_app) if installed?(current_app)
end

Given /^I uninstall it$/ do
  step %Q[I uninstall the app "#{current_app}"]
end

Then /^the (?:app|game) "([^"]*)" should( not)? be installed$/ do |path, negation|
  set_current_app(path)
  should negation, app, be_installed(current_app)
end

Then /^it should( not)? be installed$/ do |negation|
  step %Q[the app "#{current_app}" should#{negation} be installed]
end
