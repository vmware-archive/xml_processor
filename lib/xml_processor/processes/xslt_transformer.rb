require 'nokogiri'

module XmlProcessor
  module Processes
    class XsltTransformer
      def initialize(xslt_path, dest_extension: '.html')
        @xslt_path = xslt_path
        @dest_extension = dest_extension
      end

      def call(files)
        files.reduce({}) do |hash, (filename, file_content)|
          document = Dir.chdir(File.dirname(filename)) do |dir|
            Nokogiri::XML(file_content) {|c| c.xinclude }
          end

          template = Nokogiri::XSLT(File.open xslt_path)

          html_filename = filename.to_s.split('.').first + dest_extension
          transformed_data = template.transform(document).to_xml

          hash.merge({html_filename => transformed_data})
        end
      end

      private

      attr_reader :xslt_path, :dest_extension
    end
  end
end
