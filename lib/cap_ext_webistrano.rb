require 'cap_ext_webistrano/task'

module CapExtWebistrano
  def hijack_capistrano
    puts "Hijacking Capistrano for fun, profit, and Webistrano"
    @hijack_runner = lambda { CapExtWebistrano::Task.new(current_task.fully_qualified_name).run }
    tasks.each {|tsk| tsk.last.instance_variable_set(:@body, @hijack_runner)}
    namespaces.each {|nmspace| nmspace.last.tasks.each {|tsk| tsk.last.instance_variable_set(:@body, @hijack_runner)}}
  end
  
  def task(*args, &blk)
    original_task(*args, &@hijack_runner)
  end

  def after(*args)
  end

  def on(*args)
  end

  def before(*args)
  end
end

self.class.class_eval do
  alias :original_task :task
end
Capistrano::Configuration::Namespaces.class_eval do
  include CapExtWebistrano
end

self.extend(CapExtWebistrano)
hijack_capistrano