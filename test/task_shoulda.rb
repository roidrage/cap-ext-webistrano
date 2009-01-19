$:.unshift(File.dirname(File.expand_path(__FILE__)))
require 'test_helper.rb'
require 'cap_ext_webistrano/project'
require 'cap_ext_webistrano/task'


class TaskTest < Test::Unit::TestCase
  context "when running a task" do
    setup do
      @config = Capistrano::Configuration.new
      @config[:webistrano_home] = "http://localhost:3000"
      @config[:password] = "bacon"
      @config[:user] = "chunky"
      @task = CapExtWebistrano::Task.new("deploy", @config)
    end
    
    should "set the access data for project" do
      @task.run
      assert_equal "http://localhost:3000", Project.site.to_s
      assert_equal "chunky", Project.user
      assert_equal "bacon", Project.password
    end
  end
end