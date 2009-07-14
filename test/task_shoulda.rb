$:.unshift(File.dirname(File.expand_path(__FILE__)))
require 'test_helper.rb'
require 'cap_ext_webistrano/project'
require 'cap_ext_webistrano/task'
require 'cap_ext_webistrano/stage'
require 'cap_ext_webistrano/deployment'


class TaskTest < Test::Unit::TestCase
  context "with a new task" do
    setup do
      @config = Capistrano::Configuration.new
      @config[:webistrano_home] = "http://localhost:3000"
      @config[:password] = "bacon"
      @config[:user] = "chunky"
      @task = CapExtWebistrano::Task.new("deploy", @config)
      @task.set_access_data
      @task.stubs(:sleep)
    end
    
    context "when setting up the configuration data" do
      should "set the access data for project" do
        assert_equal "http://localhost:3000", Project.site.to_s
        assert_equal "chunky", Project.user
        assert_equal "bacon", Project.password
      end
    
      should "set the access data for the stage" do
        assert_equal "http://localhost:3000/projects/:project_id", Stage.site.to_s
        assert_equal "chunky", Stage.user
        assert_equal "bacon", Stage.password
      end
    
      should "set the access data for the deployment" do
        assert_equal "http://localhost:3000/projects/:project_id/stages/:stage_id", Deployment.site.to_s
        assert_equal "chunky", Deployment.user
        assert_equal "bacon", Deployment.password
      end
    end
    
    context "when running the task" do
      setup do
        @project1 = Project.new(:name => "Bacon", :id => 2)
        @project2 = Project.new(:name => "Chunky", :id => 1)
        Project.stubs(:find).returns([@project1, @project2])
        @stage1 = Stage.new(:name => "test", :id => 3)
        Stage.stubs(:find).returns([@stage1])
        @deployment = Deployment.new(:completed_at => Time.now, :log => "Chunky bacon!", :status => "success")
        Deployment.stubs(:create).returns @deployment
        Deployment.stubs(:find).returns(@deployment)
        @config[:application] = "Bacon"
        @config[:stage] = "test"
      end
      
      should "find the project" do
        Project.expects(:find).returns([@project1, @project2])
        @task.run
      end
      
      should "find the stage" do
        Stage.expects(:find).with(:all, :params => {:project_id => 2}).returns([@stage1])
        @task.run
      end
      
      should "create a deployment" do
        Deployment.expects(:create).with(:task => "deploy", :project_id => 2, :stage_id => 3, :description => nil).returns(@deployment)
        @task.run
      end
      
      should "find the latest deployment" do
        Deployment.expects(:find).returns @deployment
        @task.run
      end
      
      context "when requesting the deployment multiple times" do
        setup do
          @seq = sequence("latest")
          @deployment1 = Deployment.new(:completed_at => nil, :log => "Chunky bacon", :id => 2)
          @deployment2 = Deployment.new(:completed_at => Time.now, :log => "Chunky bacon is my bitch", :id => 2)
          @deployment1.stubs(:status).returns("success")
          Deployment.stubs(:create).returns(@deployment1)
        end
        
        should "concat the deployment log" do
          Deployment.expects(:find).returns(@deployment1).in_sequence(@seq)
          Deployment.expects(:find).returns(@deployment2).in_sequence(@seq)
          @task.run
          assert_equal "Chunky bacon is my bitch", @task.log
        end
      end
    end
  end
end