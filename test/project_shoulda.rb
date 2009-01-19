$:.unshift(File.dirname(File.expand_path(__FILE__)))
require 'test_helper.rb'
require 'cap_ext_webistrano/project'

class ProjectTestCase < Test::Unit::TestCase
  should "set the base url for project" do
    Project.site = "http://localhots:3000"
  end
end