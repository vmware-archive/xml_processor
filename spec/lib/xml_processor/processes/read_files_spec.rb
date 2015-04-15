require_relative '../../../../lib/xml_processor/processes/read_files'

module XmlProcessor
  module Processes
    describe ReadFiles do
      it 'reads all filepaths given and returns a new hash' do
        filepath = 'spec/fixtures/test_files/file_1.xml'
        transformable_files = {filepath => nil}
        file_reader = ReadFiles.new
        expect(file_reader.call(transformable_files)[filepath]).to include('File 1 Document Title')
      end
    end
  end
end
