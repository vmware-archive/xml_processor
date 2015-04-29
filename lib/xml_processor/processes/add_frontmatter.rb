require 'nokogiri'

module XmlProcessor
  module Processes
    class AddFrontmatter
      def initialize(default_title)
        @default_title = default_title
      end

      def call(files)
        files.reduce({}) do |output, (filename, contents)|
          doc = Nokogiri::HTML(contents)
          doc_titles = doc.xpath('//head/title')
          title = if doc_titles.any? && !doc_titles.first.inner_html.empty?
                    doc_titles.first.inner_html
                  else
                    default_title
                  end

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
  end
end
