require 'rspec/core/rake_task'

task default: %w[spec]

task :convert, [:dir] do |t, args|
  require 'pathname'
  require_relative 'lib/xml_processor/converter'
  require_relative 'lib/xml_processor/processes/xyleme_xml_processor'
  require_relative 'lib/xml_processor/processes/non_xml_processor'

  output_dir = Pathname.new(ENV['XML_OUTPUT_DIR'] || 'output')
  XmlProcessor::Converter.build(output_dir).run(args.to_a)
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
