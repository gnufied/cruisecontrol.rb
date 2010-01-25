require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class TwitterNotifierTest < Test::Unit::TestCase
  include FileSandbox
  BUILD_LOG = <<-EOL
    blah blah blah
    something built
    tests passed / failed / etc
  EOL
  def setup
    setup_sandbox
    @project = Project.new("myproj")
    @project.path = @sandbox.root
    @build = Build.new(@project, 5)
    @previous_build = Build.new(@project, 4)
    Configuration.dashboard_url = "http://localhost"
    
    @notifier = TwitterNotifier.new
    @notifier.username = "foo"
    @notifier.password = "bar"
    
    @project.add_plugin(@notifier,:test_twitter_notifier)
  end

  def teardown
    teardown_sandbox
  end

  def test_do_nothing_with_passing_build
    mock_client = mock()
    mock_client.expects(:update).never
    Twitter::Base.expects(:new).never
    @notifier.build_finished(@build)
  end

  def test_send_twit_when_build_failed
    mock_client = mock()
    mock_client.expects(:update).returns(true)
    Twitter::Base.expects(:new).returns(mock_client)
    @notifier.build_finished(failing_build)
  end

  def test_send_twit_when_build_fixed
    mock_client = mock()
    mock_client.expects(:update).returns(true)
    Twitter::Base.expects(:new).returns(mock_client)
    @notifier.build_fixed(@build,@previous_build)
  end

  private
  def failing_build
    @build.stubs(:failed?).returns(true)
    @build.stubs(:output).returns(BUILD_LOG)
    @build
  end
end

