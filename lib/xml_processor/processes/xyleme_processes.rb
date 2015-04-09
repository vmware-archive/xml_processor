require_relative 'add_file_extensions'
require_relative 'add_frontmatter'
require_relative 'replace_words_in_text'
require_relative 'write_in_directory'
require_relative 'xslt_processor'

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
          AddFileExtensions.new(%w[erb]),
          AddFrontmatter.new('Pivotal Hadoop Documentation'),
          WriteInDirectory.new(output_dir)
        ].each(&block)
      end

      private

      attr_reader :output_dir
    end
  end
end
