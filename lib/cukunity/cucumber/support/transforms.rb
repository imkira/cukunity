# -*- coding: UTF-8 -*-

Transform /^(\d+(?:\.\d+)?)\s*s(?:ecs?|econds?)$/ do |time|
  time.to_f
end
