require_relative '../../lib/github_client'

describe GithubClient do
  describe 'cloning and pushing a repo' do
    xit 'pushes local changes to remote repository' do
      rambo_value = rand(1..100)

      Dir.mktmpdir do |tmpdir|
        Dir.chdir(tmpdir) do
          GithubClient.new.clone('git@github.com:cf-pub-tools/dummy.git')
          lines = File.readlines("#{tmpdir}/dummy/README.md")
          lines_with_new_value = lines.map do |line|
            if line.to_i != 0
              rambo_value
            end
          end

          lines_with_new_value.each do |line|
            File.open("#{tmpdir}/dummy/README.md", 'w') { |file| file.write(line) }
          end

          GithubClient.new.push("#{tmpdir}/dummy")
        end
      end

      Dir.mktmpdir do |tmpdir|
        Dir.chdir(tmpdir) do
          GithubClient.new.clone('git@github.com:cf-pub-tools/dummy.git')
          expect(File.read('dummy/README.md')).to include("#{rambo_value}")
        end
      end
    end
  end
end