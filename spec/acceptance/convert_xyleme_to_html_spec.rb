require_relative '../helpers/environment_helpers'

describe 'converting any number of directories containing xml files to html' do

  around_in_xyleme_tmpdir(ENV)

  let(:output_dir) { ENV['XYLEME_OUTPUT_DIR'] }

  it 'creates an html file for each xml file in the input directories, preserving directory structure' do
    `bundle exec rake convert[spec/fixtures/test_files,spec/fixtures/more_test_files]`

    expect(File.exist? "#{output_dir}/spec/fixtures/test_files/file_1.html").to eq true
    expect(File.exist? "#{output_dir}/spec/fixtures/test_files/file_2.html").to eq true
    expect(File.exist? "#{output_dir}/spec/fixtures/more_test_files/file_3.html").to eq true
    expect(File.exist? "#{output_dir}/spec/fixtures/more_test_files/file_4.html").to eq true
  end

  it 'populates the html files correctly' do
    `bundle exec rake convert[spec/fixtures/test_files,spec/fixtures/more_test_files]`

    expect(File.read "#{output_dir}/spec/fixtures/test_files/file_1.html").to include('<ul class="number-list">')
    expect(File.read "#{output_dir}/spec/fixtures/test_files/file_2.html").to include('<div xmlns:xy="http://xyleme.com/xylink" class="figure">')
    expect(File.read "#{output_dir}/spec/fixtures/more_test_files/file_3.html").to include('<ul class="number-list">')
    expect(File.read "#{output_dir}/spec/fixtures/more_test_files/file_4.html").to include('<div xmlns:xy="http://xyleme.com/xylink" class="figure">')
  end

  it 'copies over each non-xml file from the input directories into the appropriate output directory, preserving directory structure' do
    `bundle exec rake convert[spec/fixtures/test_files,spec/fixtures/more_test_files]`

    expect(File.exist? "#{output_dir}/spec/fixtures/test_files/images/img_1.png").to eq true
    expect(File.exist? "#{output_dir}/spec/fixtures/more_test_files/pdfs/doc_1.pdf").to eq true
  end
end

