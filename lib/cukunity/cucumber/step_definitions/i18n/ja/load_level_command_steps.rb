# -*- coding: UTF-8 -*-

Given /^レベル"([^"]*)"をロード(?:している)?$/ do |name|
  step %Q[I load "#{name}" level]
end

Given /^レベル(\d+)をロード(?:している)?$/ do |number|
  step %Q[I load level #{number}]
end

Then /^レベル"([^"]*)"が(?:ロード|再生)されてい(る|ない)(?:こと)?$/ do |name, negation|
  step %Q[it should#{negation} be playing "#{name}" level]
end

Then /^レベル(\d+)が(?:ロード|再生)されてい(る|ない)(?:こと)?$/ do |number, negation|
  step %Q[it should#{negation} be playing level #{number}]
end
