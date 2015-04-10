require_relative '../../../../lib/xml_processor/processes/match_xml_type'

module XmlProcessor
  module Processes
    describe MatchXmlType do
      it 'selects files that contain the desired XML identifier and returns a hash' do
        files = {
            'file.xml' => "<RootNode><OtherNode></OtherNode></RootNode>",
            'file_2.xml' => "<WrongRootNode><SomeRandomNode></SomeRandomNode></WrongRootNode>"
        }

        matcher = MatchXmlType.new(:RootNode)
        expect(matcher.call files).to eq({ 'file.xml' => "<RootNode><OtherNode></OtherNode></RootNode>" })
      end
    end
  end
end