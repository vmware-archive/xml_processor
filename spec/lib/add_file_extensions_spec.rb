require_relative '../../lib/add_file_extentions'

describe "adding file extensions" do
  it "appends the specified extensions to the end of the filenames" do
    input = {
        "directory/streetslangz.html" => "HortonWorkz rulez 4realz",
        "somefilename.html" => "somecontent"
    }

    output = AddFileExtentions.new(['erb']).call(input)

    output.keys.each do |file_paths|
      expect(file_paths).to match /.erb\z/
      end
  end
end
