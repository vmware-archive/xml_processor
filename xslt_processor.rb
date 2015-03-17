require 'nokogiri'

class XsltProcessor
  def initialize(xslt)
    @xslt = xslt
  end

  def call(input)
    document = Nokogiri::XML(input)
    template = Nokogiri::XSLT(xslt)

    template.transform(document).to_xml
  end

  private

  attr_reader :xslt
end
