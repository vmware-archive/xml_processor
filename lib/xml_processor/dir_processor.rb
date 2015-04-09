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
      @xml_files ||= filtered_files { |f| is_xml_file?(f) }
    end

    def other_files
      @other_files ||= filtered_files { |f| is_non_xml_file?(f) }
    end

    def filtered_files(&filter)
      files.map { |f| Pathname(f) }.select(&filter)
    end

    def files
      @files ||= Dir.glob("#{dir}/**/*")
    end

    def is_xml_file?(filepath)
      filepath.file? && filepath.extname == '.xml'
    end

    def is_non_xml_file?(filepath)
      filepath.file? && filepath.extname != '.xml'
    end
  end
end

