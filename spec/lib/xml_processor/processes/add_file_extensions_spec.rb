require_relative '../../../../lib/xml_processor/processes/add_file_extensions'

module XmlProcessor
  module Processes
    describe "adding file extensions" do
      it "appends the specified extensions to the end of the filenames" do
        input = {
          "directory/streetslangz.html" => "HortonWorkz rulez 4realz",
          "somefilename.html" => "somecontent"
        }

        output = AddFileExtensions.new(['erb']).call(input)

        output.keys.each do |file_paths|
          expect(file_paths).to match /.erb\z/
        end
      end
    end
  end
end
