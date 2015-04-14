require 'fileutils'
require_relative '../helpers/filename_helpers'

module XmlProcessor
  class DirProcessor
    def initialize(dir, output_dir)
      @dir = dir
      @output_dir = output_dir
    end

    def call(processors)
      FileUtils.remove_dir("#{output_dir}/#{dir}", true)
      transformable_paths = transformable(files.
                                          map { |f| Pathname(f) }.
                                          select(&:file?))
      processors.each do |processor|
        processor.call(transformable_paths)
      end
    end

    private

    attr_reader :dir, :files, :xml_files, :output_dir

    def transformable(paths)
      paths.reduce({}) { |hash, filepath| hash.merge(filepath => nil) }
    end

    def files
      Dir.glob("#{dir}/**/*")
    end
  end
end

