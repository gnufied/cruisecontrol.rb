require "fileutils"

class ContinuousDeployment < BuilderPlugin
  include FileUtils
  def initialize(project = nil)
    @project = project
    @revision = @project.revision[0..6]
  end

  def build_finished(build)
    if(build.successful? && @project.auto_deploy)
      cd(@project.path) do
        CruiseControl::Log.event("Going to auto deploy to #{@project.deploy_env} and revision #{@revision}")
        run("cap #{@project.deploy_env} deploy DEPLOY_SHA=#{@revision}")
      end
    end
  end

  def run(cmd)
    system(cmd)
    if($?.to_i != 0)
      CruiseControl::Log.event("Error while running #{cmd}",:debug)
    else
      CruiseControl::Log.event("Successful running command #{cmd}",:debug)
    end
  end
end

Project.plugin :continuous_deployment

