require_relative 'xslt_processor'
require 'fileutils'
require 'pathname'

FileUtils.rm_rf('output') if Dir.exist?('output')

ARGV.each do |a|
  FileUtils.mkdir_p("output/#{a}")
  files = Dir.glob("#{a}/**/*")
  xyleme_files = files.select {|f| File.file?(f) && f.split('.').last == 'xml'}
  other_files = files.select {|f| File.file?(f) && f.split('.').last != 'xml' }

  xyleme_files.each do |file|
    contents = File.read(file)
    xsl_stylesheet = File.read('xyleme_to_html.xsl')
    processor = XsltProcessor.new(xsl_stylesheet)
    output = processor.call(contents)
    new_filename = file.split('.').first
    File.open("output/#{new_filename}.html", 'w+') { |file| file.write(output) }
  end

  other_files.each do |file|
    dest_path = Pathname("output/#{file}")
    FileUtils.mkpath(File.dirname(dest_path))
    FileUtils.copy(file, dest_path)
  end
end
