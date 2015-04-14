module XmlProcessor
  module Processes
    class ReadFiles
      def call(transformable_files)
        transformable_files.reduce({}) do |acc, (filepath, _)|
          acc.merge(filepath => File.read(filepath))
        end
      end
    end
  end
end
