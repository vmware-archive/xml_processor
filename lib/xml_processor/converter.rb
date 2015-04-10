require_relative 'dir_processor'

module XmlProcessor
  class Converter
    def initialize(output_dir, xml_processors, non_xml_processor)
      @output_dir = output_dir
      @xml_processors = xml_processors
      @non_xml_processor = non_xml_processor
    end

    def run(dirs)
      dirs.each do |dir|
        DirProcessor.new(dir, output_dir).call(xml_processors, non_xml_processor)
      end
    end

    private

    attr_reader :output_dir, :xml_processors, :non_xml_processor
  end
end

