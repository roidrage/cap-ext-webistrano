require 'cap_ext_webistrano/project'

module CapExtWebistrano
  class Task
    def initialize(task, config)
      @task = task
      @config = config
    end

    def set_access_data
      Project.site = @config[:webistrano_home]
      Project.user = @config[:user]
      Project.password = @config[:password]
    end
    
    def run
      set_access_data
      puts "Running task #{@task} via Webistrano at #{@config[:webistrano_home]}"
    end
  end
end