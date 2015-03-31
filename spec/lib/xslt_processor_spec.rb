require 'tmpdir'
require_relative '../../lib/xslt_processor'

describe XsltProcessor do
  context "when given the Xyleme template" do
    it "returns a single hash of filenames to file contents" do
      processor = XsltProcessor.new(xslt)
      results = processor.call('file1.xml' => '<IA/>',
                               'file2.xml' => '<IA/>')
      expect(results['file1.html']).to be_html
      expect(results['file2.html']).to be_html
    end

    it "puts the title in the <title> tag" do
      expect(html.css('html>head>title').text).to eq('The Document Title')
    end

    it "transforms subtitle into a h2" do
      expect(html.css('html>body h2').first.text).to eq('MyDoc 2.1.2')
    end

    it "transforms Lesson Titles into h2s" do
      expect(html.css('html>body .lessons h2').first.text).to eq('First Lesson')
    end

    it "correctly preserves ids for Lesson Title h2s" do
      h2 = html.css('html>body .lessons h2').first
      expect(h2.attr('id')).to eq('ref-c3182b23-4ac2-4905-8641-8517c321c3bb')
    end

    it "transforms Topic Titles into h3s with associated ids from Topic" do
      h3 = html.css('html>body h3').first
      expect(h3.text).to eq('Topic 1')
      expect(h3.attr('id')).to eq('ref-57cff955-33e8-42b3-a485-268e7eb603fb')
    end

    it "transforms nested Topic Titles into h4s" do
      h4 = html.css('html>body h4').first
      expect(h4.text).to eq('Topic 4')
    end

    it "correctly preserves ids for h4s" do
      h4 = html.css('html>body h4').first
      expect(h4.attr('id')).to eq('ref-an-h4-guid')
    end

    it "assigns ids to all headings" do
      expect(html.css('h1,h2,h3,h4')).to have_ids
    end

    it "has no duplicate ids" do
      ids = html.xpath('//@id')
      expect(ids.to_a.uniq.count).to eq(ids.count)
    end

    it "transforms RichTexts double-linebreak into double-br" do
      fake_paras = html.css('html>body p')[0].to_xhtml.split(%r(<br /><br />))
      expect(fake_paras[0]).to match(%r(<p>.*Blah blah this is the best lesson\.)m)
      expect(fake_paras[1]).to match(%r(Look! Two paragraphs\..*</p>)m)
    end

    it "transforms Hrefs into as" do
      link = html.css('html>body p a')[0]
      expect(link.text).to eq('google')
      expect(link.attr('href')).to eq('https://www.google.com/')
    end

    it "transforms Xrefs into as with internal anchors" do
      link = html.css('html>body p a')[1]
      expect(link.text).to eq('Oh yeah here it is')
      expect(link.attr('href')).to eq('#ref-63da0add-37c7-4c4f-b453-8c00d8cffc45')
    end

    it "transforms Lists into uls with nested ps" do
      items = html.css('html>body ul>li>p')
      expect(items.first.text).to match(/Look.*-- Great stuff on this item/m)
    end

    context "transforming Notices" do
      it "transforms RichText into ps" do
        expect(html.css('html>body footer p')[1].text).to eq('Pubdate: March 11, 2015')
      end
    end

    matcher :have_ids do
      match do |elements|
        elements.map {|h| h.attr('id') }.none?(&:nil?)
      end

      failure_message do |elements|
        "The following elements have nil ids:\n" +
          elements.select {|h| h.attr('id').nil?}.
          map(&:to_xhtml).join("\n")
      end
    end

    matcher :be_html do
      match do |actual|
        actual.match(/\A<!DOCTYPE html/)
      end
    end

    def debug(html)
      tmp = Pathname(File.expand_path('../../../../../tmp', __FILE__))
      tmp.mkpath
      path = tmp.join('output.html')
      File.write(path, html)
      `open #{path}`
      puts html
    end

    let(:output_hash) {
      processor = XsltProcessor.new(xslt)
      processor.call({'some_file.xml' => xyleme})
    }

    let(:html) {
      Nokogiri::HTML(output_hash.fetch('some_file.html'))
    }

    let(:xyleme) {
      <<-XYLEME
<IA xmlns:xy="http://xyleme.com/xylink" xy:type="IA/Definitions/IADef.xml" xy:guid="6bcab63c-43f7-49a1-bc2b-e7570bca2c9d">
<CoverPage>
<Title>The Document Title</Title>
<SubTitle>MyDoc 2.1.2</SubTitle>
<Notice>
  <Title/>
  <ParaBlock xy:guid="d19cc5bc-0e50-4dbe-8a8a-7a13553dc0c1">
    <RichText>
      This work by
      <Href UrlTarget="http://www.camelpunch.com">Camel Punch</Href>
      is licensed under a
      <Href UrlTarget="http://creativecommons.org/licenses/by-sa/3.0/">
        Creative Commons Attribution-ShareAlike 3.0 Unported License
      </Href>
      .
    </RichText>
    <RichText>Pubdate: March 11, 2015</RichText>
  </ParaBlock>
  <FilterMetadata xy:guid="8e33a8d6-f286-4b84-82b2-abfa48fe5424"/>
</Notice>
</CoverPage>
<Credits>
<CopyrightBlock xy:guid="72ce60e2-cc28-4c5a-bd37-09cd93bf0619">
  <RichText>This is a copyright notice.</RichText>
  <RichText>
    It has
    <Href UrlTarget="http://www.some.place/">a link</Href>
    in it.
  </RichText>
</CopyrightBlock>
<CopyrightDate>1983-2015</CopyrightDate>
</Credits>
<Lessons>
<Lesson xy:guid="c3182b23-4ac2-4905-8641-8517c321c3bb">
  <Title>First Lesson</Title>
  <Topic xy:guid="57cff955-33e8-42b3-a485-268e7eb603fb">
    <Title>Topic 1</Title>
    <ParaBlock xy:guid="3c2589d7-22e8-4716-89d8-69b4074bf214">
      <RichText>
        Blah blah this is the <InlineCode>best</InlineCode> lesson.

        Look! Two paragraphs.
      </RichText>
      <RichText>
        I am about to link externally, look!
        <Href UrlTarget="https://www.google.com/">google</Href>
      </RichText>
      <RichText>
        I am about to link internally, look!
        <Xref InsideTargetRef="63da0add-37c7-4c4f-b453-8c00d8cffc45">Oh yeah here it is</Xref>
      </RichText>
    </ParaBlock>
  </Topic>
  <Topic xy:guid="63da0add-37c7-4c4f-b453-8c00d8cffc45">
    <Title>Topic 2</Title>
    <ParaBlock xy:guid="9765ce69-96b3-42fd-b633-7675cead6302">
      <RichText>
        A topic with a list
      </RichText>
      <List ListMarker="Bullet" xy:guid="40f1d32b-00ef-48b9-979a-a9c74fa49165">
        <ItemBlock>
          <Item>
            <ItemPara>
              <Emph>Look</Emph>
              -- Great stuff on this item
            </ItemPara>
          </Item>
          <Item>
            <ItemPara>
              <Emph>Here</Emph>
              -- More excellent content
            </ItemPara>
            <RichText>Text inside a list item</RichText>
          </Item>
        </ItemBlock>
      </List>
      <RichText>
        Below a list
      </RichText>
    </ParaBlock>
  </Topic>
  <Topic xy:guid="63da0add-37c7-4c4f-b453-8c00d8cffc4h4no-1">
    <Topic xy:guid="an-h4-guid">
      <Title>Topic 4</Title>
    </Topic>
    <Title>Topic 2</Title>
    <ParaBlock xy:guid="9765ce69-96b3-42fd-b633-7675cead6302h4no-1">
      <RichText>
        A topic with a list
      </RichText>
      <List ListMarker="Bullet" xy:guid="40f1d32b-00ef-48b9-979a-a9c74fa49165h4no-1">
        <ItemBlock>
          <Item>
            <ItemPara>
              <Emph>Look</Emph>
              -- Great stuff on this item
            </ItemPara>
          </Item>
          <Item>
            <ItemPara>
              <Emph>Here</Emph>
              -- More excellent content
            </ItemPara>
            <RichText>Text inside a list item</RichText>
          </Item>
        </ItemBlock>
      </List>
      <RichText>
        Below a list
      </RichText>
    </ParaBlock>
  </Topic>
</Lesson>
</Lessons>
<DesignData xy:schema-version="Core/Definitions/Metadata/DesignData.xsd#core-3.9-0" xy:guid="2825002e-d29b-42f6-9ed2-6fba31e60437">
<LOM xy:schema-version="Core/Definitions/Metadata/LOM.xsd#core-3.9-0" xy:guid="68ac5dee-05c1-4453-b880-daa35d72a192">
  <LifeCycle xy:guid="da31fe6d-6496-4abf-86b4-bf501024af20">
    <Version xy:schema-version="Core/Definitions/Metadata/LOM.xsd#core-3.9-0" xy:guid="7a9c9793-1fbf-42b1-974a-3186aec12d78">HDP 2.2</Version>
    <Status xy:schema-version="Core/Definitions/Metadata/LOM.xsd#core-3.9-0" xy:guid="72405049-a1fb-49c9-9b4b-3be8c224deb3">final</Status>
  </LifeCycle>
  <AttributeGroup xy:guid="bb712461-a556-4392-af03-2509e2c960c4">
    <Attribute xy:schema-version="Core/Definitions/Metadata/LOM.xsd#core-3.9-0" xy:guid="56d5ea7e-b716-402b-80ca-86dd809e186f">
      <Name>Publication Date</Name>
      <Date>2015-03-11</Date>
    </Attribute>
  </AttributeGroup>
</LOM>
</DesignData>
</IA>
      XYLEME
    }
    let(:xslt) { File.read(File.expand_path('../../../xyleme_to_html.xsl', __FILE__)) }
  end
end
