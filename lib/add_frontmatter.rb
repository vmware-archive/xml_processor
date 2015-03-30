require 'nokogiri'

class AddFrontmatter
  def initialize(default_title)
    @default_title = default_title
  end

  def call(files)
    files.inject({}) do |output, (filename, contents)|
      doc = Nokogiri::XML(contents)
      doc_titles = doc.xpath('//head/meta/title')
      title_text = doc_titles.inner_html
      title = !title_text.empty? ? title_text : default_title

      frontmatter = <<-FRONTMATTER
---
title: #{title}
---
      FRONTMATTER

      transformed_data = frontmatter + contents
      output.merge({filename => transformed_data})
    end
  end

  private

  attr_reader :default_title
end