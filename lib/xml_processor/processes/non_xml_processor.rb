require_relative 'filter_extensions'
require_relative 'copy_to_output_dir'

module XmlProcessor
  module Processes
    class NonXmlProcessor
      def initialize(output_dir)
        @output_dir = output_dir
      end

      def call(transformable_files)
        [
          FilterExtensions.new('.xml', :reject),
          CopyToOutputDir.new(output_dir)
        ].reduce(transformable_files) { |acc, subprocess| subprocess.call(acc) }
      end

      private

      attr_reader :output_dir
    end
  end
end

