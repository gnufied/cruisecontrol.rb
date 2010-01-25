require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class TwitterNotifierTest < Test::Unit::TestCase
  include FileSandbox
  def setup
    setup_sandbox
    @project = Project.new("myproj")
    @project.path = @sandbox.root
    @build = Build.new(@project, 5)
    @previous_build = Build.new(@project, 4)
    
    @notifier = TwitterNotifier.new
    @notifier.account = "foo"
    @notifier.password = "bar"
    
    @project.add_plugin(@notifier,:test_twitter_notifier)
  end

  def teardown
    teardown_sandbox
  end

  def test_do_nothing_with_passing_build
    @notifier.build_finished(@build)
  end

  def test_send_twit_when_build_failed
    
  end

  def test_send_twit_when_build_fixed
    
  end
end

