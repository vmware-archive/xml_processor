require 'pathname'
require_relative 'dir_processor'

module XmlProcessor
  class Converter
    def initialize(output_dir, processor)
      @output_dir = output_dir
      @processor = processor
    end

    def run(dirs)
      dirs.each do |dir|
        DirProcessor.new(dir, output_dir).call(processor)
      end
    end

    private

    attr_reader :processor

    def output_dir
      Pathname(@output_dir)
    end
  end
end

