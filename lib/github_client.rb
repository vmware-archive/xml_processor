require 'git'

class GithubClient
  def clone(remote)
    repo_name = remote.split(':').last.split('/').last.gsub(/.git/, '')
    Git.clone(remote, repo_name, path: nil)
  end

  def push(directory)
    g = Git.open(directory)
    g.add
    g.commit('automated push')
    g.push
  end
end