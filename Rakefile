task default: %w[build]

task :build, [:dirs] do |t, args|
  ruby "main.rb real_files"

  `open "./output/real_files/ambari.html"`
end
