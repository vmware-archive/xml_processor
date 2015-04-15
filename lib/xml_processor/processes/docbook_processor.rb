module XmlProcessor
  module Processes
    class DocbookProcessor
      def initialize(output_dir)
        @output_dir = output_dir
      end

      def call(transformable_files)
        [
            FilterExtensions.new('.xml', :select),
            ReadFiles.new,
            MatchXmlType.new(root_element),
            XsltProcessor.new(File.open('lib/xml_processor/stylesheets/docbook-html5/docbook-html5.xsl'),
                              dest_extension: '.html.erb'),
            WriteInDirectory.new(output_dir)
        ].reduce(transformable_files) { |acc, subprocess| subprocess.call(acc) }
      end

      private

      attr_reader :output_dir

      def root_element
        :book
      end
    end
  end
end
