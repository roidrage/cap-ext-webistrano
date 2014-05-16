require 'cap_ext_webistrano/project'
require 'cap_ext_webistrano/stage'
require 'cap_ext_webistrano/deployment'
require 'cap_ext_webistrano/host'

module CapExtWebistrano
  class Task
    attr_accessor :task, :log

    def initialize(task, config)
      @task = task
      @config = config
      @log = ""
    end

    def set_access_data
      [Project, Stage, Deployment, Host].each do |klazz|
        klazz.configure(@config)
      end
    end

    def loop_latest_deployment
      still_running = true
      prefix_options = @deployment.prefix_options
      while still_running
        sleep 5
        @deployment.prefix_options.merge!(prefix_options)
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
      params = {}

      if @config[:host_to_deploy]
        hosts_all = Host.all
        host_to_deploy = Host.find_by_name(@config[:host_to_deploy])
        do_not_deploy_hosts = hosts_all - [host_to_deploy]
        hosts_ids = do_not_deploy_hosts.collect {|h| h.id}
        params = { :task => task, :stage_id => @stage.id, :project_id => @project.id, :description => @config[:description], :excluded_host_ids => hosts_ids }
      else
        params = { :task => task, :stage_id => @stage.id, :project_id => @project.id, :description => @config[:description]}
      end

      params.merge!(:prompt_config => @config[:prompt_config]) if @config.exists?(:prompt_config)
      @deployment = Deployment.create(params)
      loop_latest_deployment
      exit(-1) unless @deployment.status == "success"
    end
  end
end
