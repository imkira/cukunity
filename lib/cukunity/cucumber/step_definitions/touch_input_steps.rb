# -*- coding: UTF-8 -*-

When /^I tap the screen(down up|down and up| down| up)? at coordinates (\d+), (\d+)$/ do |type, x, y|
  type = (type || ' down and up').strip.gsub(/ /, '_').downcase
  screen.tap :x => x.to_i, :y => y.to_i
end

When /^I tap "([^"]*)"(?: and wait ((?:\d+(?:\.\d+)?)\s*s(?:ecs?|econds?)))?$/ do |name, time|
  screenable = hint(:type => 'screen') do |hint|
    hint.gameobject.name == name and hint.on_screen?
  end
  should 'not', screenable, be_nil
  screenable.tap :wait => (time || touch.default_tap_delay).to_f
end

When /^I set the default tap (?:wait|delay) to ((?:\d+(?:\.\d+)?)\s*s(?:ecs?|econds?))$/ do |time|
  touch.set_default_tap_delay(time.to_f)
end
