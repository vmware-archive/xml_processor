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
    FileUtils.chdir(directory) do
        g = Git.open(directory)
        g.config('user.name', 'pipeline')
        g.config('user.email', 'email@example.com')
        begin
        g.add
        g.commit('automated push')
        g.push
      rescue Git::GitExecuteError => e
        error = GithubClientPushError.new(e.message)

        @listeners.map {|listener| listener.report_error(error)}
      end
    end
  end

  def add_listener(listener)
    @listeners.push(listener)
  end
end
