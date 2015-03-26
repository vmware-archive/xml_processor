require 'pathname'
require_relative 'lib/pusher'
require_relative 'lib/view_updater'

ARGV.each do |arg|
  view_updater = ViewUpdater.new
  github_client = GithubClient.new
  github_client.add_listener(view_updater)
  Pusher.new(github_client, Pathname.new(File.expand_path('../', __FILE__))).run(arg)
end

