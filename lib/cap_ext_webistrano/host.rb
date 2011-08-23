class Host < ActiveResource::Base
 def self.configure(config)
   Host.site = config[:webistrano_home]
   Host.user = config[:user]
   Host.password = config[:password]
 end

  def self.find_by_name(name)
    host = find(:all).find {|host| host.name == name}
  end

end
