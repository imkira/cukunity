# -*- coding: UTF-8 -*-

When /^I type "([^"]*)"(?: using "([^"]*)")?$/ do |text, method|
  keyboard.open(:clear => true, :method => method) do |k|
    k.type_text text
  end
end

When /^I append "([^"]*)"(?: using "([^"]*)")?$/ do |text, method|
  keyboard.open(:clear => false, :method => method) do |k|
    k.type_text text
  end
end
