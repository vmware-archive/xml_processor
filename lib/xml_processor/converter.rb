require 'pathname'
require_relative 'dir_processor'

module XmlProcessor
  class Converter
    def initialize(output_dir, processes)
      @output_dir = output_dir
      @processes = processes
    end

    def run(dirs)
      dirs.each do |dir|
        DirProcessor.new(dir, output_dir).call(processes)
      end
    end

    private

    attr_reader :processes

    def output_dir
      Pathname(@output_dir)
    end
  end
end

