require 'nokogiri'

class XsltProcessor
  def initialize(xslt)
    @xslt = xslt
  end

  def call(files)
    files.map do |file|
      filename = file.keys.first
      file_content = file[filename]
      document = Nokogiri::XML(file_content)
      template = Nokogiri::XSLT(xslt)

      html_filename = filename.split('.').first + ".html"
      transformed_data = template.transform(document).to_xml


      {html_filename => transformed_data}
    end
  end

  private

  attr_reader :xslt
end
