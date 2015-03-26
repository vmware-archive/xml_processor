require 'git'

class GithubClient
  GithubClientPushError = Class.new(RuntimeError)

  def initialize
    @listeners = []
  end

  def clone(remote)
    repo_name = remote.split(':').last.split('/').last.gsub(/.git/, '')
    Git.clone(remote, repo_name, path: nil)
  end

  def push(directory)
    g = Git.open(directory)
    begin
      g.add
      g.commit('automated push')
      g.push
    rescue Git::GitExecuteError => e
      error = GithubClientPushError.new(e.message)

      @listeners.map {|listener| listener.report_error(error)}
    end
  end

  def add_listener(listener)
    @listeners.push(listener)
  end
end