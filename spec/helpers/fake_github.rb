class FakeGithub
  def initialize(repo)
    @repo = repo
    @clone_repos = []
  end

  def clone_repo(repo_name)
    @clone_repos.push(repo_name)
  end

  def update_repo(new_files)
    repo.update_files(new_files)
  end

  def has_only_received_clone_repo?(repo_name)
    @clone_repos.last == repo_name && @clone_repos.size == 1
  end

  def repo_with(org_name, repo_name)
    repos.select {|repo| repo.org == org_name && repo.name == repo_name}.first
  end

  attr_reader :repo
end

class FakeGitAccessor
  def initialize(github, clone_dirs)
    @github = github
    @clone_dirs = clone_dirs
  end

  def clone(github_address)
    github.clone_repo(github_address)

    repo_name = github_address.split(':').last.split('/').last.gsub(/.git/, '')
    repo_dir = File.join(@clone_dirs, repo_name)

    Dir.mkdir(repo_dir)
    Dir.chdir(repo_dir) do
      FileUtils.touch('file.txt')
      FileUtils.touch('.git')
    end
  end

  def push(directory)
    content_file_locations = Dir.glob("#{directory}/**/*.*")
    hidden_file_locations = Dir.glob("#{directory}/**/.*")
    files = content_file_locations + hidden_file_locations
    contents = files.map { |file| file.split("repo/").last }
    github.update_repo(contents)
  end

  private

  attr_reader :github
end

class FakeGitRepo
  def initialize(org, name, directory)
    @org = org
    @name = name
    @directory = directory
  end

  def contents
    @directory.files
  end

  def dirname
    name
  end

  def update_files(files)
    @directory = Directory.new(files)
  end

  attr_reader :org, :name, :directory
end

class Directory
  def initialize(files = [])
    @files = files
  end

  def add_files(new_files)
    @files += new_files
  end

  attr_reader :files
end
