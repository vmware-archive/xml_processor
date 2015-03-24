require 'nokogiri'

class XsltProcessor
  def initialize(xslt)
    @xslt = xslt
  end

  def call(files)
    files.map do |file|
      key = file.keys.first
      value = file[key]
      document = Nokogiri::XML(value)
      template = Nokogiri::XSLT(xslt)

      html_filename = key.split('.').first + ".html"
      transformed_data = template.transform(document).to_xml


      {html_filename => transformed_data}
    end
  end

  private

  attr_reader :xslt
end
