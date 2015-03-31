require 'rspec/core/rake_task'

task default: %w[convert]

task :convert, [:dir] do |t, args|
  system "ruby convert.rb #{args.to_a.join(' ')}"
end

task :push, [:remote] do |t, args|
  remote = args[:remote]
  system "ruby push.rb #{remote}"
end

task :show_output, [:file] do |t, args|
  file = args[:file] || "output/real_files/ambari.html.erb"
  without_erb = file.sub(/\.erb$/, '')
  FileUtils.cp(file, without_erb)
  system %Q(open "#{without_erb}")
end

RSpec::Core::RakeTask.new(:spec)
