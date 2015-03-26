require_relative 'github_client'

class Pusher
  def initialize(github_client, context)
    @github_client = github_client
    @context = context
  end

  def run(remote, contents_dir)
    Dir.chdir(@context) do
      @github_client.clone(remote)
    end

    system "cp -r #{contents_dir.join('.')} #{@context.join('output')}"

    repo_name = remote.split(':').last.split('/').last.gsub(/.git/, '')
    path_to_repo = @context.join(repo_name)

    FileUtils.rm_f Dir.glob("#{path_to_repo}/**/*")
    contents = Dir.glob File.join("#{@context}/output", '**')
    contents.each do |dir|
      FileUtils.cp_r dir, path_to_repo
    end

    @github_client.push(path_to_repo)
  end
end
