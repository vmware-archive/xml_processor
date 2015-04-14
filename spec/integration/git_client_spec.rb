require_relative '../../lib/git_client'

describe GitClient do
  it 'adds, commits and pushes local changes to remote repository' do
    with_tmpdir_repo("remote-repo", "README.md", "# Some repo") do |git, parent_path|
      in_dir('intermediate-clone-dir') do |dir|
        git.clone(parent_path.join('remote-repo').to_s)
        File.write("remote-repo/another-doc.md", "# Another doc")
        git.push parent_path.join(dir, "remote-repo")
      end

      in_dir('final-clone-dir') do
        git.clone(parent_path.join('remote-repo').to_s)
        expect(File.read("remote-repo/README.md")).to eq("# Some repo")
        expect(File.read("remote-repo/another-doc.md")).to eq("# Another doc")
      end
    end
  end

  context 'when there is nothing to commit' do
    it 'report error to listeners' do
      with_tmpdir_repo("remote-repo", "README.md", "# Some repo") do |git, parent_path|
        listener = double('listener', report_error: nil)
        git.add_listener(listener)

        in_dir('clone-dir') do |dir|
          git.clone(parent_path.join('remote-repo').to_s)
          git.push parent_path.join(dir, "remote-repo")
        end

        expect(listener).to have_received(:report_error)
      end
    end
  end

  def in_dir(dirname, &block)
    Dir.mkdir(dirname)
    Dir.chdir(dirname) do |arg|
      block.call(arg)
    end
  end

  def with_tmpdir_repo(repo_name, initial_filename, initial_file_content, &block)
    git = GitClient.new

    Dir.mktmpdir do |tmpdir|
      path = Pathname(tmpdir)

      Dir.chdir(tmpdir) do
        in_dir('remote-repo') do
          system "git init --quiet"
          system "git config user.email 'tester@testing.land'"
          system "git config user.name 'Auto Tester'"
          system "git config receive.denyCurrentBranch ignore"
          File.write(initial_filename, initial_file_content)
          system "git add ."
          system "git commit --quiet -m first-commit"
        end

        block.call(git, path)
      end
    end
  end
end
