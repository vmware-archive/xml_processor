#!/usr/bin/env ruby

require 'pathname'
require_relative 'lib/xml_processor/converter'
require_relative 'lib/xml_processor/processes/xyleme_xml_processor'
require_relative 'lib/xml_processor/processes/non_xml_processor'

output_dir = Pathname.new(ENV['XML_OUTPUT_DIR'] || 'output')
XmlProcessor::Converter.new(
  output_dir,
  XmlProcessor::Processes::XylemeXmlProcessor.new(output_dir),
  XmlProcessor::Processes::NonXmlProcessor.new(output_dir)
).run(ARGV)

