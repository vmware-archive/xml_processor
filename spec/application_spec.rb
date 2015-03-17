describe Application do

  it 'transforms xylene into html' do
    `./xylene-to-html xylene.xml`
    File.read
  end
end
