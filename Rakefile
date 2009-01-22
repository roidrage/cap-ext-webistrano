require 'rubygems'
require 'rake'
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = 'cap-ext-webistrano'
    s.summary = 'A drop-in replacement for Capistrano to fire off Webistrano deployments transparently without losing the joy of using the cap command.'
    s.email = 'meyer@paperplanes.de'
    s.homepage = 'http://github.com/mattmatt/cap-ext-webistrano'
    s.authors = ["Mathias Meyer"]
    s.files = FileList["[A-Z]*", "{lib,test}/**/*"]
    s.add_dependency 'capistrano'
    s.add_dependency 'activeresource'
  end
rescue LoadError 
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com" 
end

desc "Default Task"
task :default => ["test"]

desc "Runs the unit tests"
task :test => "test:unit"

namespace :test do
  desc "Unit tests"
  Rake::TestTask.new(:unit) do |t|
    t.libs << 'test/unit'
    t.pattern = "test/*_shoulda.rb"
    t.verbose = true
  end
end