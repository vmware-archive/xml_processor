require_relative '../../lib/replace_words'

describe "replacing words" do
  it "replaces a single word in all of the content" do
    input = {
      "directory/streetslangz" => "HortonWorkz rulez 4realz",
      "somefilename" => "somecontent"
    }
    output = ReplaceWords.new("HortonWorkz" => "Pivotal Software").
        call(input)

    expect(output["directory/streetslangz"]).to eq("Pivotal Software rulez 4realz")
  end
end
