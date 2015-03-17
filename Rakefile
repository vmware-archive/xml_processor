task default: %w[build]

task :build, [:dirs] do |t, args|
  ruby "main.rb examples"
  `open "./output/examples/example_1.html"`
end
