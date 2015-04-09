require 'fileutils'
require_relative '../helpers/filename_helpers'

module XmlProcessor
  class DirProcessor
    UNDERSCORE_WHITESPACE_EXTENSIONS = %w[.jpg .jpeg .png .tif .tiff .emf]

    def initialize(dir, output_dir)
      @dir = dir
      @output_dir = output_dir
    end

    def call(processor)
      FileUtils.remove_dir("#{output_dir}/#{dir}", true)
      processor.call(transformable_files)
      copy_to_formatted_paths(other_files)
    end

    private

    attr_reader :dir, :files, :xml_files, :output_dir

    def copy_to_formatted_paths(src_paths)
      src_paths.each do |src_path|
        output_dir.join(format_file_path(src_path)).tap do |dest_path|
          dest_path.dirname.mkpath
          FileUtils.copy(src_path, dest_path)
        end
      end
    end

    def format_file_path(path)
      if UNDERSCORE_WHITESPACE_EXTENSIONS.include?(path.extname)
        path.to_s.gsub(' ', '_')
      else
        path
      end
    end

    def transformable_files
      xml_files.reduce({}) do |hash, filepath|
        hash.merge(filepath => File.read(filepath))
      end
    end

    def xml_files
      @xml_files ||= files.select { |f| is_xml_file?(f) }
    end

    def other_files
      @other_files ||= files.select { |f| is_non_xml_file?(f) }.map { |f| Pathname(f) }
    end

    def files
      @files ||= Dir.glob("#{dir}/**/*")
    end
  end
end

