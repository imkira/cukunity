# -*- coding: UTF-8 -*-

When /^(?:"([^"]*)"という入力方法で)?"([^"]*)"と入力(?:したら)?$/ do |method, text|
  if method.nil?
    step %Q[I type "#{text}"]
  else
    step %Q[I type "#{text}" using "#{method}"]
  end
end

When /^(?:"([^"]*)"という入力方法で)?"([^"]*)"と加えて入力(?:したら)?$/ do |method, text|
  if method.nil?
    step %Q[I append "#{text}"]
  else
    step %Q[I append "#{text}" using "#{method}"]
  end
end
