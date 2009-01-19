module CapExtWebistrano
  class Task
    def initialize(task, config)
      @task = task
      @config = config
    end
    
    def run
      puts "Running task #{@task} via Webistrano at #{@config[:webistrano_home]}"
    end
  end
end