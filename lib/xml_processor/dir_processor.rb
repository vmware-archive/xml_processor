require 'fileutils'
require_relative '../add_file_extentions'
require_relative '../add_frontmatter'
require_relative '../helpers/filename_helpers'
require_relative '../replace_words_in_text'
require_relative '../write_in_directory'
require_relative '../xslt_processor'
require_relative 'processes/xyleme_processes'

module XmlProcessor
  class DirProcessor
    UNDERSCORE_WHITESPACE_EXTENSIONS = %w[.jpg .jpeg .png .tif .tiff .emf]

    def initialize(dir, output_dir)
      @dir = dir
      @output_dir = output_dir
    end

    def call
      FileUtils.remove_dir("#{output_dir}/#{dir}", true)
      processes(output_dir).reduce(transformable_files) { |arg, process| process.call(arg) }
      copy_to_formatted_paths(other_files)
    end

    private

    attr_reader :dir, :files, :xml_files, :output_dir

    def processes(output_dir)
      Processes::XylemeProcesses.new(output_dir)
    end

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

