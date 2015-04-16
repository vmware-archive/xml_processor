require_relative '../processes/match_xml_type'
require_relative '../processes/add_frontmatter'
require_relative '../processes/replace_words_in_text'
require_relative '../processes/write_in_directory'
require_relative '../processes/xslt_processor'
require_relative '../processes/filter_extensions'
require_relative '../processes/read_files'

module XmlProcessor
  module Processes
    class XylemeXmlProcessor
      def initialize(output_dir)
        @output_dir = output_dir
      end

      def call(transformable_files)
        [
          FilterExtensions.new('.xml', :select),
          ReadFiles.new,
          MatchXmlType.new(root_element),
          XsltProcessor.new(xslt_path, dest_extension: '.html.erb'),
          ReplaceWordsInText.new('Hortonworks' => 'Pivotal'),
          AddFrontmatter.new('Pivotal Hadoop Documentation'),
          WriteInDirectory.new(output_dir)
        ].reduce(transformable_files) { |acc, subprocess| subprocess.call(acc) }
      end

      private

      attr_reader :output_dir

      def root_element
        :IA
      end

      def xslt_path
        'lib/xml_processor/stylesheets/xyleme_to_html.xsl'
      end

    end
  end
end
