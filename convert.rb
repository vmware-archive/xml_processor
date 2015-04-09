#!/usr/bin/env ruby

require 'pathname'
require_relative 'lib/xml_processor/converter'
require_relative 'lib/xml_processor/processes/xyleme_processor'

output_dir = ENV['XYLEME_OUTPUT_DIR'] || 'output'
XmlProcessor::Converter.new(
  Pathname.new(output_dir),
  XmlProcessor::Processes::XylemeProcessor.new(output_dir)
).run(ARGV)

