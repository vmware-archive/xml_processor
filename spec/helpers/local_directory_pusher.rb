class LocalDirectoryPusher
  def initialize(git_accessor, fs_accessor)
    @git_accessor = git_accessor
    @fs_accessor = fs_accessor
  end
end