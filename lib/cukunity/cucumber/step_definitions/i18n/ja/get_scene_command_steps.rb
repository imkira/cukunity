# -*- coding: UTF-8 -*-

Then /^"([^"]*)"という(\w+)が存在してい(る|ない)(?:こと)?$/ do |name, type, negation|
  step %[I should#{negation} have a #{type} named "#{name}"]
end

Then /^"([^"]*)"が存在してい(る|ない)(?:こと)?$/ do |name, negation|
  step %[I should#{negation} have a GameObject named "#{name}"]
end

Then /^その中に(\w+)(?:コンポーネント)?が存在してい(る|ない)(?:こと)?$/ do |type, negation|
  step %[it should#{negation} have a #{type} component]
end

Then /^その中に(\w+)というプロパティーが存在してい(る|ない)(?:こと)?$/ do |name, negation|
  step %[it should#{negation} have a property named "#{name}"]
end

Then /^その中に"(\w+)"というプロパティーが存在してい(る|ない)(?:こと)?$/ do |name, negation|
  step %[it should#{negation} have a property named "#{name}"]
end

Then /^その中に(\w+)(?:というプロパティー)?が"([^"]*)"(?:と|に)一致してい(る|ない)(?:こと)?$/ do |name, value, negation|
  step %Q[it should#{negation} have "#{name}" property equal to "#{value}"]
end

Then /^その中に"(\w+)"(?:というプロパティー)?が"([^"]*)"(?:と|に)一致してい(る|ない)(?:こと)?$/ do |name, value, negation|
  step %Q[it should#{negation} have "#{name}" property equal to "#{value}"]
end

Then /^その中に"(\w+)"(?:というプロパティー)?が有効になってい(る|ない)(?:こと)?$/ do |bool_name, negation|
  step %Q[it should#{negation} be "#{bool_name}"]
end

Then /^その中に(\w+)(?:というプロパティー)?が有効になってい(る|ない)(?:こと)?$/ do |bool_name, negation|
  step %Q[it should#{negation} be "#{bool_name}"]
end
