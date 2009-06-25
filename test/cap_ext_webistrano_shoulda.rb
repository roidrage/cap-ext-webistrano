$:.unshift(File.dirname(File.expand_path(__FILE__)))

require 'test_helper'
require 'cap_ext_webistrano'
require 'capistrano_stub'
require 'cap_ext_webistrano/task'

class CapExtWebistranoTest < Test::Unit::TestCase
  context "when executing tasks" do
    setup do
      @cap = CapistranoStub.new
      CapExtWebistrano::Task.stubs(:new).returns @cap
    end
    
    should "convert all tasks to use the hijacking task" do
      @cap.find_and_execute_task("deploy")
      assert_nothing_raised {@cap.task.body.call}
    end
    
    should "call run on the task runner" do
      @cap.find_and_execute_task("deploy")
      assert @cap.ran
    end
    
    should "just call tasks that don't exist locally" do
      @cap.stubs(:original_find_and_execute_task).raises(Capistrano::NoSuchTaskError.new, "the task activate:web does not exist")
      @cap.find_and_execute_task("acticate:web")
      assert @cap.ran
    end
  end
end