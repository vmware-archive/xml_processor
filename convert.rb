require 'pathname'
require_relative 'lib/xml_processor/converter'

output_dir = ENV['XYLEME_OUTPUT_DIR'] || 'output'
Converter.new(Pathname.new(output_dir)).run(ARGV)

