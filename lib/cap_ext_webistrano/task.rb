require 'cap_ext_webistrano/project'
require 'cap_ext_webistrano/stage'
require 'cap_ext_webistrano/deployment'

module CapExtWebistrano
  class Task
    attr_accessor :task, :log
    
    def initialize(task, config)
      @task = task
      @config = config
      @log = ""
    end

    def set_access_data
      [Project, Stage, Deployment].each do |klazz|
        klazz.configure(@config)
      end
    end
    
    def loop_latest_deployment
      still_running = true
      while still_running
        sleep 5
        @deployment.reload
        print_diff(@deployment)
        still_running = false unless @deployment.completed_at.nil?
      end
    end
    
    def print_diff(deployment)
      if deployment.log
        diff = deployment.log
        diff.slice!(log) 
        print diff
        log << diff
      end
    end
    
    def run
      set_access_data
      @project = Project.find_by_name(@config[:application])
      @stage = @project.find_stage(@config[:stage])
      Deployment.prefix = "#{@config[:webistrano_home]}/projects/#{@project.id}/stages/#{@stage.id}/"
      @deployment = Deployment.create(:task => task, :stage_id => @stage.id, :project_id => @project.id)
      loop_latest_deployment
    end
  end
end
