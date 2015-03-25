require 'rake'
require_relative '../helpers/output'
require_relative '../../lib/pusher'
require_relative '../../lib/converter'

class ApplicationRunner
  def initialize(github_client, tmp_dir)
    @github_client = github_client
    @tmp_dir = tmp_dir
  end

  def convert_directories(directories)
    Converter.new(Pathname.new(File.join(@tmp_dir, 'output'))).run(directories)
  end

  def push_to_remote(remote)
    Pusher.new(@github_client, Pathname.new(@tmp_dir)).run(remote)
  end
end