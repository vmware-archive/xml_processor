require 'pathname'
require_relative 'dir_processor'

module XmlProcessor
  class Converter
    def initialize(output_dir)
      @output_dir = output_dir
    end

    def run(dirs)
      dirs.each do |dir|
        DirProcessor.new(dir, output_dir).call
      end
    end

    private

    def output_dir
      Pathname(@output_dir)
    end
  end
end

