require 'fileutils'
require 'pathname'
require_relative 'add_file_extentions'
require_relative 'add_frontmatter'
require_relative 'helpers/filename_helpers'
require_relative 'replace_words_in_text'
require_relative 'write_in_directory'
require_relative 'xslt_processor'

class Converter
  SUPPORTED_EXTS = %w[jpg jpeg png tif tiff emf]

  def initialize(output_dir)
    @output_dir = output_dir
  end

  def run(dirs)
    dirs.each do |dir|
      FileUtils.remove_dir("#{@output_dir}/#{dir}", true)

      files = Dir.glob("#{dir}/**/*")
      xml_files = files.select { |f| is_xml_file?(f) }
      other_files = files.select { |f| is_non_xml_file?(f) }

      xyleme_files = xml_files.reduce({}) do |hash, filepath|
        file_contents = File.read(filepath)
        hash.merge(filepath => file_contents)
      end

      processes = [
          XsltProcessor.new(File.read('xyleme_to_html.xsl')),
          ReplaceWordsInText.new('Hortonworks' => 'Pivotal'),
          AddFileExtentions.new(%w[erb]),
          AddFrontmatter.new('Pivotal Hadoop Documentation'),
          WriteInDirectory.new(@output_dir)
      ]

      processed_output = processes.reduce(xyleme_files) { |arg, process| process.call(arg) }

      other_files.each do |file|
        file_extension = File.extname(file).gsub('.', '')
        formatted_file_path = SUPPORTED_EXTS.include?(file_extension) ? file.gsub(' ', '_') : file

        dest_path = Pathname("#{@output_dir}/#{formatted_file_path}")
        dest_path.dirname.mkpath
        FileUtils.copy(file, dest_path)
      end
    end
  end
end
