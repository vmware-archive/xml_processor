require_relative 'xslt_processor'
require_relative 'replace_words'
require_relative 'add_file_extentions'
require_relative 'write_to_file'
require_relative 'add_frontmatter'
require_relative 'helpers/filename_helpers'
require 'fileutils'
require 'pathname'

class Converter
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

      [XsltProcessor.new(File.read('xyleme_to_html.xsl')),
        ReplaceWords.new('Hortonworks' => 'Pivotal'),
        AddFileExtentions.new(%w[erb]),
        AddFrontmatter.new('Pivotal Hadoop Documentation'),
        WriteToFile.new(@output_dir)].inject(xyleme_files) { |arg, process| process.call(arg) }

      other_files.each do |file|
        dest_path = Pathname("#{@output_dir}/#{file}")
        FileUtils.mkpath(File.dirname(dest_path))
        FileUtils.copy(file, dest_path)
      end
    end
  end
end
