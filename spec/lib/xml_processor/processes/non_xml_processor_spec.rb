require 'tmpdir'
require_relative '../../../../lib/xml_processor/processors/non_xml_processor'

module XmlProcessor
  module Processes
    describe NonXmlProcessor do
      it "copies all files without .xml extension to the output dir" do
        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            expected_dest_1 = "myoutput/file_1.png"
            src_content_1 = "foo"
            File.write("file 1.png", src_content_1)
            File.write("file2.xml", "whatever")
            NonXmlProcessor.new(Pathname("myoutput")).call(
              Pathname("file 1.png") => nil,
              Pathname("file2.xml") => nil
            )
            expect(File.read(expected_dest_1)).to eq(src_content_1)
            expect(File.exists?("myoutput/file2.xml")).to be_falsy
          end
        end
      end
    end
  end
end
