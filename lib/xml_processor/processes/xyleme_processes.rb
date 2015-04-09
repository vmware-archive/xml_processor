module XmlProcessor
  module Processes
    class XylemeProcesses
      include Enumerable

      def initialize(output_dir)
        @output_dir = output_dir
      end

      def each(&block)
        [
          XsltProcessor.new(File.read('xyleme_to_html.xsl')),
          ReplaceWordsInText.new('Hortonworks' => 'Pivotal'),
          AddFileExtentions.new(%w[erb]),
          AddFrontmatter.new('Pivotal Hadoop Documentation'),
          WriteInDirectory.new(output_dir)
        ].each(&block)
      end

      private

      attr_reader :output_dir
    end
  end
end
