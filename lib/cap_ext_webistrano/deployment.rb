class Deployment < ActiveResource::Base
  def self.configure(config)
    Deployment.site = "#{config[:webistrano_home]}/projects/:project_id/stages/:stage_id"
    Deployment.user = config[:user]
    Deployment.password = config[:password]
  end
end