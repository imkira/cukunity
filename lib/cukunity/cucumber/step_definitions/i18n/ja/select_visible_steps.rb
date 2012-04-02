# -*- coding: UTF-8 -*-

Then /^"([^"]*)"(?:というGameObject)?を表示してい(る|ない)(?:こと)?$/ do |name, negation|
  step %Q[I should#{negation} see "#{name}"]
end

Then /^"([^"]*)"と表示してい(る|ない)(?:こと)?$/ do |text, negation|
  step %Q[I should#{negation} read "#{text}"]
end
