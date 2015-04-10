require 'fileutils'
require_relative '../helpers/filename_helpers'

module XmlProcessor
  class DirProcessor
    def initialize(dir, output_dir)
      @dir = dir
      @output_dir = output_dir
    end

    def call(xml_processors, non_xml_processor)
      FileUtils.remove_dir("#{output_dir}/#{dir}", true)
      xml_processors.each do |xml_root_node, processor|
        processor.call(matching(xml_root_node, transformable(xml_files)))
      end
      non_xml_processor.call(transformable_keys_only(other_files))
    end

    private

    attr_reader :dir, :files, :xml_files, :output_dir

    def matching(xml_root_node, file_hash)
      file_hash.select {|filename, file_contents| Nokogiri::XML(file_contents).xpath("/#{xml_root_node}")}
    end

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

