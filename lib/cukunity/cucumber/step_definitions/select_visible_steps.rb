# -*- coding: UTF-8 -*-

Then /^I should( not)? see "([^"]*)"$/ do |negation, name|
  screenable = hint(:type => 'screen') do |hint|
    hint.gameobject.name == name and hint.on_screen?
  end
  should !negation, screenable, be_nil
end

Then /^I should( not)? read "([^"]*)"$/ do |negation, text|
  textual = hint(:type => 'text') do |hint|
    hint.reads_as?(text)
  end
  should !negation, textual, be_nil
end
