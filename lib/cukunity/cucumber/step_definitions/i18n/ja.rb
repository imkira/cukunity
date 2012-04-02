# -*- coding: UTF-8 -*-

Transform /^(る|ない)$/ do |negation|
  /^(ない)$/.match(negation) ? ' not' : nil
end

Transform /^(\d+(?:\.\d+)?)秒/ do |time|
  time.to_f
end
