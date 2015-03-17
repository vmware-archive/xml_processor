require_relative 'xslt_processor'
require 'fileutils'

ARGV.each do |a|
  FileUtils.rm_rf('output') if Dir.exist?('output')
  FileUtils.mkdir_p("output/#{a}")
  xyleme_files = Dir.glob("#{a}/**/*")
  xyleme_files.each do |file|
    contents = File.read(file)
    xsl_stylesheet = File.read('xyleme_to_html.xsl')
    processor = XsltProcessor.new(xsl_stylesheet)
    output = processor.call(contents)
    new_filename = file.split('.').first
    File.open("output/#{new_filename}.html", 'w+') { |file| file.write(output) }
  end
end
