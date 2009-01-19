require 'test/unit'
require 'rubygems'

gem 'thoughtbot-shoulda', '>= 2.0.0'
require 'shoulda'

$:.unshift(File.join(File.dirname(File.expand_path(__FILE__)), "..", "lib"))