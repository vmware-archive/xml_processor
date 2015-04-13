module XmlProcessor
  module Processes
    class FilterExtensions
      def initialize(extension, function)
        @extension = extension
        @function = function
      end

      def call(files)
        files.public_send(function) { |filepath, _| filepath.extname == extension }
      end

      private
      attr_reader :extension, :function
    end
  end
end
