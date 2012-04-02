# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "cukunity"
  gem.homepage = "http://github.com/imkira/cukunity"
  gem.license = "MIT"
  gem.summary = %Q{cukunity is an automation/testing framework that simplifies BDD testing of Unity 3D games.}
  gem.description = %Q{cukunity is a tool inspired by the principles of Behaviour Driven Development. Cukunity is a portmanteau of "Cucumber" and "Unity", and as so it provides helpers to play nicely with cucumber, although it can be used standalone for automation. }
  gem.email = "imkira@gmail.com"
  gem.authors = ["Mario Freitas"]
  # dependencies defined in Gemfile
  gem.add_dependency 'json', '>= 1.6.5'
  gem.add_dependency 'term-ansicolor', '>= 1.0.6'
end
Jeweler::RubygemsDotOrgTasks.new

require 'cucumber/rake/task'
namespace :features do
  load File.join(File.dirname(__FILE__), 'lib/cukunity/tasks/cucumber.rake')
end

require 'reek/rake/task'
Reek::Rake::Task.new do |t|
  t.fail_on_error = true
  t.verbose = false
  t.source_files = 'lib/**/*.rb'
end

require 'roodi'
require 'roodi_task'
RoodiTask.new do |t|
  t.verbose = false
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
