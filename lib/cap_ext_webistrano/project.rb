require 'active_resource'

class Project < ActiveResource::Base
  def self.configure(config)
    Project.site = config[:webistrano_home]
    Project.user = config[:user]
    Project.password = config[:password]
  end
  
  def self.find_by_name(name)
    project = find(:all).find {|project| project.name == name}
  end
  
  def find_stage(name)
    Stage.find(:all, :params => {:project_id => id}).find {|stage| stage.name == name}
  end
end