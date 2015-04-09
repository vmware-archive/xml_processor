require 'fileutils'
require_relative '../helpers/filename_helpers'

module XmlProcessor
  class DirProcessor
    def initialize(dir, output_dir)
      @dir = dir
      @output_dir = output_dir
    end

    def call(processor, non_xml_processor)
      FileUtils.remove_dir("#{output_dir}/#{dir}", true)
      processor.call(transformable(xml_files))
      non_xml_processor.call(transformable_keys_only(other_files))
    end

    private

    attr_reader :dir, :files, :xml_files, :output_dir

    def transformable(paths)
      paths.reduce({}) { |hash, filepath| hash.merge(filepath => filepath.read) }
    end

    def transformable_keys_only(paths)
      Hash[paths.zip([nil] * paths.count)]
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

