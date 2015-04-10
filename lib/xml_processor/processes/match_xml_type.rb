require 'nokogiri'

module XmlProcessor
  module Processes
    class MatchXmlType
      def initialize(identifier)
        @identifier = identifier
      end

      def call(files)
        files.select {|filename, file_contents| Nokogiri::XML(file_contents).xpath("/#{identifier}").any? }
      end

      private

      attr_reader :identifier
    end
  end
end