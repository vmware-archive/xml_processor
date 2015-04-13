module XmlProcessor
  module Processes
    class CopyToOutputDir
      UNDERSCORE_WHITESPACE_EXTENSIONS = %w[.jpg .jpeg .png .tif .tiff .emf]

      def initialize(output_dir)
        @output_dir = output_dir
      end

      def call(transformable_files)
        transformable_files.keys.each do |src_path|
          output_dir.join(format_file_path(src_path)).tap do |dest_path|
            dest_path.dirname.mkpath
            FileUtils.copy(src_path, dest_path)
          end
        end
      end

      private

      attr_reader :output_dir

      def format_file_path(path)
        if UNDERSCORE_WHITESPACE_EXTENSIONS.include?(path.extname)
          path.to_s.gsub(' ', '_')
        else
          path
        end
      end
    end
  end
end
