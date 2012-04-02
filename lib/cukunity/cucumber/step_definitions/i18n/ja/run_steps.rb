# -*- coding: UTF-8 -*-

Given /^"([^"]*)"(?:から)?(?:アプリ|ゲーム)を(再)?起動(?:している)?$/ do |path, relaunch|
  step %Q[I #{relaunch}launch the app "#{path}"]
end

Given /^(?:その|同)?(?:アプリ|ゲーム)を(再)?起動(?:している)?$/ do |relaunch|
  step %Q[I #{relaunch}launch the app "#{current_app}"]
end

Then /^"([^"]*)"(?:アプリ|ゲーム)が(?:実行|動作)してい(る|ない)(?:こと)?$/ do |path, negation|
  step %Q[the app "#{path}" should#{negation} be running]
end

Then /^(?:その|同)?(?:アプリ|ゲーム)が(?:実行|動作)してい(る|ない)(?:こと)?$/ do |negation|
  step %Q[the app "#{current_app}" should#{negation} be running]
end

Then /^"([^"]*)"(?:アプリ|ゲーム)がフォアグラウンドで(?:実行|動作)してい(る|ない)(?:こと)?$/ do |path, negation|
  step %Q[the app "#{path}" should#{negation} be running on foreground]
end

Then /^(?:その|同)?(?:アプリ|ゲーム)がフォアグラウンドで(?:実行|動作)してい(る|ない)(?:こと)?$/ do |negation|
  step %Q[the app "#{current_app}" should#{negation} be running on foreground]
end
