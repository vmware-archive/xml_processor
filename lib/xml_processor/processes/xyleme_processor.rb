require_relative 'add_frontmatter'
require_relative 'replace_words_in_text'
require_relative 'write_in_directory'
require_relative 'xslt_processor'

module XmlProcessor
  module Processes
    class XylemeProcessor
      def initialize(output_dir)
        @output_dir = output_dir
      end

      def call(transformable_files)
        [
          XsltProcessor.new(File.read('xyleme_to_html.xsl'), dest_extension: '.html.erb'),
          ReplaceWordsInText.new('Hortonworks' => 'Pivotal'),
          AddFrontmatter.new('Pivotal Hadoop Documentation'),
          WriteInDirectory.new(output_dir)
        ].reduce(transformable_files) { |acc, subprocess| subprocess.call(acc) }
      end

      private

      attr_reader :output_dir
    end
  end
end
