require "twitter"

class TwitterNotifier < BuilderPlugin
  attr_accessor :username, :password
  def initialize(project = nil)
    @username = Configuration.twitter_username
    @password = Configuration.twitter_password
  end

  def auth_info?
    return false if(@username.blank? || @password.blank?)
    true
  end

  def build_finished(build)
    return if(!auth_info?)
    twit(build, "#{build.project.name} build #{build.abbreviated_label} failed")
  end

  def build_fixed(build)
    return if not !auth_info?
    twit(build,"#{build.project.name} build #{build.abbreviated_label} fixed")
  end

  def twit(build, messsage)
    twitter_auth_info = Twitter::HTTPAuth.new(@username,@password,:ssl => true)
    client = Twitter::Base.new(twitter_auth_info)
    client.update(messsage)
  end
end

