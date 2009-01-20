require 'capistrano'

class CapistranoStub
  include Capistrano::Configuration::Namespaces
  include Capistrano::Configuration::Execution
  attr_accessor :task, :ran
  
  def logger
    Logger.new(STDOUT)
  end
  
  def find_task(*args)
    @task ||= Capistrano::TaskDefinition.new("deploy", top, {}) { raise "This shouldn't be raised" }
  end
  
  def original_find_and_execute_task(*args)
    find_task.body.call
  end
  
  def namespaces
    {:default => top}
  end
  
  def tasks
    @tasks = {"deploy" => find_task}
  end
  
  def current_task
    find_task
  end
  
  def [](key)
    "admin"
  end
  
  def run
    @ran = true
  end
end