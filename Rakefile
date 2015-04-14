require 'rspec/core/rake_task'

task default: %w[spec]

desc "Process all files in a directory, optionally set XML_OUTPUT_DIR (default 'output')"
task(:convert, [:dir] => :update_submodule) do |t, args|
  require 'pathname'
  require_relative 'lib/xml_processor/converter'

  output_dir = Pathname.new(ENV['XML_OUTPUT_DIR'] || 'output')
  XmlProcessor::Converter.build(output_dir).run(args.to_a)
end

task :push, [:remote] do |t, args|
  remote = args[:remote]
  system "ruby push.rb #{remote}"
end

task :update_submodule do |t|
  system "git submodule update --init"
end

task :show_output, [:file] do |t, args|
  file = args[:file] || "output/real_files/ambari.html.erb"
  without_erb = file.sub(/\.erb$/, '')
  FileUtils.cp(file, without_erb)
  system %Q(open "#{without_erb}")
end

RSpec::Core::RakeTask.new(:spec => :update_submodule)
