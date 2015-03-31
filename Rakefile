require 'rspec/core/rake_task'

task default: %w[convert]

task :convert, [:dir] do |t, args|
  `ruby convert.rb #{args.to_a.join(' ')}`
end

task :push, [:remote] do |t, args|
  remote = args[:remote]
  system "ruby push.rb #{remote}"
end

task :show_output, [:file] do |t, args|
  file = args[:file] || "real_files/ambari.html"

  `open "./output/#{file}"`
end

RSpec::Core::RakeTask.new(:spec)
