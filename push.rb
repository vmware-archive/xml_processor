require 'pathname'
require_relative 'lib/pusher'

ARGV.each do |arg|
  Pusher.new(GithubClient.new, Pathname.new('.')).run(arg)
end




