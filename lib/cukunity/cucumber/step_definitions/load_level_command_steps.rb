# -*- coding: UTF-8 -*-

Given /^I load(?: the)? "([^"]*)" level$/ do |name|
  load_level(name)
end

Given /^I load level (\d+)$/ do |number|
  load_level(number.to_i)
end

Then /^it should( not)? be playing(?: the)? "([^"]*)" level$/ do |negation, name|
  should_equal negation, level.name, name
end

Then /^it should( not)? be playing level (\d+)$/ do |negation, number|
  should_equal negation, level.number, number.to_i
end
