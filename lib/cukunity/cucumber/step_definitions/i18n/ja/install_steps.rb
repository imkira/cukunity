# -*- coding: UTF-8 -*-

Given /^"([^"]*)"(?:から)?(?:アプリ|ゲーム)を(再)?インストール(?:している)?$/ do |path, reinstall|
  step %Q[I #{reinstall}install the app "#{path}"]
end

Given /^(?:その|同)?(?:アプリ|ゲーム)を(再)?インストール(?:している)?$/ do |reinstall|
  step %Q[I #{reinstall}install the app "#{current_app}"]
end

Given /^"([^"]*)"(?:アプリ|ゲーム)をアンインストール(?:している)?$/ do |path|
  step %Q[I uninstall the app "#{path}"]
end

Given /^(?:その|同)?(?:アプリ|ゲーム)をアンインストール(?:している)?$/ do
  step %Q[I uninstall the app "#{current_app}"]
end

Then /^"([^"]*)"(?:アプリ|ゲーム)がいインストールされていい(る|ない)(?:こと)?$/ do |path, negation|
  step %Q[the app "#{path}" should#{negation} be installed]
end

Then /^(?:その|同)?(?:アプリ|ゲーム)がインストールされてい(る|ない)(?:こと)?$/ do |negation|
  step %Q[the app "#{current_app}" should#{negation} be installed]
end
