require 'nokogiri'
require_relative '../exceptions'

module XmlProcessor
  module Processes
    class MatchXmlType
      def initialize(identifier)
        @identifier = identifier
      end

      def call(files)
        files.select { |filename, file_contents|
          begin
            Nokogiri::XML(file_contents) { |c| c.strict }.
              xpath("/#{identifier}").any?
          rescue Nokogiri::XML::SyntaxError => e
            raise InvalidXML.new(e.message)
          rescue RuntimeError => e
            raise InvalidXML.new("Unparseable XML: #{filename}")
          end
        }
      end

      private

      attr_reader :identifier
    end
  end
end
