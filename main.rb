require_relative 'lib/xslt_processor'
require_relative 'lib/replace_words'
require_relative 'lib/add_file_extentions'
require_relative 'lib/write_to_file'
require_relative 'lib/utils/call_chain'
require 'fileutils'
require 'pathname'

output_dir = ENV['XYLEME_OUTPUT_DIR'] || 'output'

def add_frontmatter(files)

  files.inject({}) do |output, (filename, contents)|
    doc = Nokogiri::XML(contents)
    title = doc.xpath('//title').inner_html
    frontmatter = <<-FRONTMATTER
---
title: #{title}
---
    FRONTMATTER

    transformed_data = frontmatter + contents
    output.merge({filename => transformed_data})
  end
end

ARGV.each do |a|
  files = Dir.glob("#{a}/**/*")
  xyleme_files = files.select {|f| File.file?(f) && f.split('.').last == 'xml'}.
                       inject({}) {|accum, filepath| accum.merge({filepath => File.read(filepath)})}
  other_files = files.select {|f| File.file?(f) && f.split('.').last != 'xml' }

  process_chain = CallChain.new(XsltProcessor.new(File.read('xyleme_to_html.xsl')),
                                ReplaceWords.new('Hortonworks' => 'Pivotal'),
                                AddFileExtentions.new(%w[erb]),
                                -> (result) { add_frontmatter(result) },
                                WriteToFile.new(output_dir)
  )

  process_chain.invoke(xyleme_files)

  other_files.each do |file|
    dest_path = Pathname("#{output_dir}/#{file}")
    FileUtils.mkpath(File.dirname(dest_path))
    FileUtils.copy(file, dest_path)
  end
end
