class Stage < ActiveResource::Base
  def self.configure(config)
    Stage.site = "#{config[:webistrano_home]}/projects/:project_id"
    Stage.user = config[:user]
    Stage.password = config[:password]
  end
end