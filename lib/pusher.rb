require_relative 'github_client'

class Pusher
  def initialize(github_client, context)
    @github_client = github_client
    @context = context
  end

  def run(remote)
    @github_client.clone(remote)

    repo_name = remote.split(':').last.split('/').last.gsub(/.git/, '')
    path_to_repo = @context.join(repo_name)

    FileUtils.chdir(path_to_repo) do
      FileUtils.rm Dir.glob("#{path_to_repo}/**/*")
      contents = Dir.glob File.join("#{@context}/output", '**')
      contents.each do |dir|
        FileUtils.cp_r dir, path_to_repo
      end

      @github_client.push(path_to_repo)
    end
  end
end
