require 'cap_ext_webistrano/project'
require 'cap_ext_webistrano/stage'
require 'cap_ext_webistrano/deployment'

module CapExtWebistrano
  class Task
    attr_accessor :task
    
    def initialize(task, config)
      @task = task
      @config = config
    end

    def set_access_data
      [Project, Stage, Deployment].each do |klazz|
        klazz.configure(@config)
      end
    end
    
    def run
      set_access_data
      project = Project.find_by_name(@config[:application])
      stage = project.find_stage(@config[:stage])
      Deployment.create(:task => task, :stage_id => stage.id, :project_id => project.id)
    end
  end
end