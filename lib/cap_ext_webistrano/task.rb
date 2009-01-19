module CapExtWebistrano
  class Task
    def initialize(task)
      @task = task
    end
    
    def run
      puts "Running task #{@task}"
    end
  end
end