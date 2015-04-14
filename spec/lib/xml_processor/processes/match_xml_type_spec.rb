require_relative '../../../../lib/xml_processor/processes/match_xml_type'

module XmlProcessor
  module Processes
    describe MatchXmlType do
      it "only permits documents containing the specified root node" do
        files = {
          'file.xml' => '<RootNode xmlns="http://my.namespace/"><OtherNode></OtherNode></RootNode>',
          'file_2.xml' => "<WrongRootNode><SomeRandomNode></SomeRandomNode></WrongRootNode>"
        }

        matcher = MatchXmlType.new(:RootNode)
        expect(matcher.call(files)).
          to eq('file.xml' => '<RootNode xmlns="http://my.namespace/"><OtherNode></OtherNode></RootNode>')
      end

      it "raises an exception when converting text not XML-parseable" do
        expect { MatchXmlType.new(:foo).call("bar" => "") }.to raise_exception(InvalidXML)
      end

      it "raises an exception when converting XML with a syntax error" do
        expect { MatchXmlType.new(:foo).call("bar" => "<baz>") }.to raise_exception(InvalidXML)
      end
    end
  end
end

