# -*- coding: UTF-8 -*-

# FIXME:
When /^I tap the screen(down up|down and up| down| up)? at coordinates (\d+), (\d+)$/ do |type, x, y|
  type = (type || ' down and up').strip.gsub(/ /, '_').downcase
  screen.tap :x => x.to_i, :y => y.to_i
end

When /^"([^"]*)"をタップ(?:して|したら)?((?:\d+(?:\.\d+)?)秒待ったら)?$/ do |name, time|
  if time.nil?
    step %Q[I tap "#{name}"]
  else
    step %Q[I tap "#{name}" and wait #{time} seconds]
  end
end

When /^タップした後に発生する遅延時間を((?:\d+(?:\.\d+)?)秒)に変更(?:したら)?$/ do |time|
  step %Q[I set the default tap delay to #{time} seconds]
end
