# -*- coding: UTF-8 -*-

Then /^I should( not)? have an? (\w+) (?:named|called|component on|on) "([^"]*)"$/ do |negation, type, name|
  set_current_gameobject(gameobject(name))
  if type == 'GameObject'
    should !negation, current_gameobject, be_nil
  elsif !negation or !current_gameobject.nil?
    should negation, current_gameobject, have_component(:type => type)
    set_current_component(current_gameobject.component(:type => type))
    should !negation, current_component, be_nil
  end
end

Then /^I should( not)? have a "([^"]*)"$/ do |negation, name|
  step %[I should#{negation} have a GameObject named "#{name}"]
end

Then /^it should( not)? have an? (\w+)(?: component)$/ do |negation, type|
  should !negation, current_gameobject.component(:type => type), be_nil
end

Then /^it should( not)? have (?:a )property (?:named|called) "(\w+)"$/ do |negation, name|
  should negation, current_object.has_property?(name), be_true
end

Then /^it should( not)? have "(\w+)"(?: property)? (?:as|equal to) "([^"]*)"$/ do |negation, name, value|
  step %Q[it should have a property named "#{name}"] unless negation
  should negation, current_object.property(name).to_s, eql(value)
end

Then /^it should( not)? have (\w+)(?: property)? (?:as|equal to) "([^"]*)"$/ do |negation, name, value|
  step %Q[it should have "#{name}" property equal to "#{value}"]
end

Then /^it should( not)? be "([^"]*)"$/ do |negation, bool_name|
  should negation, current_object.property(bool_name), eql(true)
end
