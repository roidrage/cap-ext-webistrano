require 'rubygems'
require 'rake'
require 'rake/testtask'

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