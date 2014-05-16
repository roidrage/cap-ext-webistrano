A drop-n replacement for Capistrano so you can run tasks in Webistrano from
your command line just using the cap command.

Installation
============

    gem install mattmatt-cap-ext-webistrano

Usage
=====

You can still use the capify command to generate the initial files required by
Capistrano.

In your Capfile, insert the following lines at the end.

    gem 'mattmatt-cap-ext-webistrano'
    require 'cap_ext_webistrano'

The Webistrano extensions require a couple of configuration options that you
can specify in your deploy.rb. They're pretty much the standard options you'd
configure for your application with Capistrano.

    set :application,     "My project" # The project as named in Webistrano
    set :user,            "admin"
    set :password,        "admin"
    set :stage,           "test" # specify the stage you want to deploy
    set :webistrano_home, "http://webistrano.mydomain.com"
    set :host_to_deploy, "server-name-here" #if you wish to override the host

If you only have one stage in your project this should do, however with
several stages it'd be better to ask for the stage to be deployed:

    set :stage do
      Capistrano::CLI.ui.ask "Specify the stage to deploy: "
    end

You can ask for the password too:

    set :password do
        Capistrano::CLI.password_prompt "Enter the deploy password: "
    end

Optionally, you can specify configuration that you had setup webistrano to
prompt it:

    set :prompt_config, { :password => 'mysecretpassword' }

Changes
=======

- Added support for prompt configuration (Lucas Mundim)
- Restore prefix_options hash as Active Resource lost it when reload method is called (Lucas Mundim)
- Solved "regular expression too big" exception error on large string 
output (Michael Lim)
- Workaround to solve bug in @deployment.reload() not loading the site url 
correctly (Michael Lim)

License
=======

(c) 2009 Mathias Meyer

Released under the MIT license.
