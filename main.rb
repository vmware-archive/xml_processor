require_relative 'lib/xslt_processor'
require_relative 'lib/replace_words'
require_relative 'lib/add_file_extentions'
require_relative 'lib/write_to_file'
require_relative 'lib/add_frontmatter'
require_relative 'lib/utils/call_chain'
require_relative 'lib/helpers/filename_helpers'
require 'fileutils'
require 'pathname'

output_dir = ENV['XYLEME_OUTPUT_DIR'] || 'output'

ARGV.each do |dir_to_convert|
  FileUtils.remove_dir("#{output_dir}/#{dir_to_convert}", true)

  files = Dir.glob("#{dir_to_convert}/**/*")
  xyleme_filenames = files.select { |f| is_xml_file?(f) }
  other_files = files.select { |f| is_non_xml_file?(f) }

  xyleme_files = xyleme_filenames.inject({}) do |hash, filepath|
    file_contents = File.read(filepath)
    hash.merge({filepath => file_contents})
  end

  process_chain = CallChain.new(XsltProcessor.new(File.read('xyleme_to_html.xsl')),
                                ReplaceWords.new('Hortonworks' => 'Pivotal'),
                                AddFileExtentions.new(%w[erb]),
                                AddFrontmatter.new('Pivotal Hadoop Documentation'),
                                WriteToFile.new(output_dir)
  )
  process_chain.invoke(xyleme_files)

  other_files.each do |file|
    dest_path = Pathname("#{output_dir}/#{file}")
    FileUtils.mkpath(File.dirname(dest_path))
    FileUtils.copy(file, dest_path)
  end
end


