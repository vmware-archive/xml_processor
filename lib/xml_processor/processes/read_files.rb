module XmlProcessor
  module Processes
    class ReadFiles
      def call(transformable_files)
        transformable_files.inject({}) do |acc, file_attrs|
          filepath = file_attrs.first
          acc[filepath] = File.read(filepath)
          acc
        end
      end
    end
  end
end