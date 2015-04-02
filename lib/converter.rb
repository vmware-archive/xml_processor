require_relative 'xslt_processor'
require_relative 'replace_words_in_text'
require_relative 'add_file_extentions'
require_relative 'write_in_directory'
require_relative 'add_frontmatter'
require_relative 'helpers/filename_helpers'
require 'fileutils'
require 'pathname'

class Converter
  SUPPORTED_EXTS = %w[jpg jpeg png tif tiff emf]

  def initialize(output_dir)
    @output_dir = output_dir
  end

  def run(dirs)
    dirs.each do |dir|
      FileUtils.remove_dir("#{@output_dir}/#{dir}", true)

      files = Dir.glob("#{dir}/**/*")
      xyleme_filenames = files.select { |f| is_xml_file?(f) }
      other_files = files.select { |f| is_non_xml_file?(f) }

      xyleme_files = xyleme_filenames.inject({}) do |hash, filepath|
        file_contents = File.read(filepath)
        hash.merge({filepath => file_contents})
      end

      processes = [
          XsltProcessor.new(File.read('xyleme_to_html.xsl')),
          ReplaceWordsInText.new('Hortonworks' => 'Pivotal'),
          AddFileExtentions.new(%w[erb]),
          AddFrontmatter.new('Pivotal Hadoop Documentation'),
      ]

      processed_output = processes.reduce(xyleme_files) { |arg, process| process.call(arg) }

      WriteInDirectory.new(@output_dir).call(processed_output)

      other_files.each do |file|
        file_extension = File.extname(file).gsub('.', '')
        formatted_file_path = SUPPORTED_EXTS.include?(file_extension) ? file.gsub(' ', '_') : file

        dest_path = Pathname("#{@output_dir}/#{formatted_file_path}")
        FileUtils.mkpath(File.dirname(dest_path))
        FileUtils.copy(file, dest_path)
      end
    end
  end
end
