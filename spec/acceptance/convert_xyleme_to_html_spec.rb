require 'rake'
require 'nokogiri'
require_relative '../helpers/environment_helpers'
require_relative '../helpers/output'
require_relative '../../Rakefile'

describe 'converting any number of directories containing xml files to html' do

  around_in_xyleme_tmpdir(ENV)

  it 'creates an .html.erb file for each xml file in the input directories, preserving directory structure' do
    convert('spec/fixtures/test_files', 'spec/fixtures/more_test_files')

    expect(File.exist? "#{output_dir}/spec/fixtures/test_files/file_1.html.erb").to eq true
    expect(File.exist? "#{output_dir}/spec/fixtures/test_files/file_2.html.erb").to eq true
    expect(File.exist? "#{output_dir}/spec/fixtures/more_test_files/file_3.html.erb").to eq true
    expect(File.exist? "#{output_dir}/spec/fixtures/more_test_files/file_4.html.erb").to eq true
  end

  it 'populates the .html.erb files correctly' do
    convert('spec/fixtures/test_files', 'spec/fixtures/more_test_files')

    expect(File.read "#{output_dir}/spec/fixtures/test_files/file_1.html.erb").to include('<ul class="number-list">')
    expect(File.read "#{output_dir}/spec/fixtures/test_files/file_2.html.erb").to include('<div xmlns:xy="http://xyleme.com/xylink" class="figure">')
    expect(File.read "#{output_dir}/spec/fixtures/more_test_files/file_3.html.erb").to include('<ul class="number-list">')
    expect(File.read "#{output_dir}/spec/fixtures/more_test_files/file_4.html.erb").to include('<div xmlns:xy="http://xyleme.com/xylink" class="figure">')
  end

  it 'copies over each non-xml file from the input directories into the appropriate output directory, preserving directory structure' do
    convert('spec/fixtures/test_files', 'spec/fixtures/more_test_files')

    expect(File.exist? "#{output_dir}/spec/fixtures/test_files/images/img_1.png").to eq true
    expect(File.exist? "#{output_dir}/spec/fixtures/more_test_files/pdfs/doc_1.pdf").to eq true
  end

  it 'adds a title frontmatter' do
    convert('spec/fixtures/test_files', 'spec/fixtures/more_test_files')

    files = Dir.glob("#{output_dir}/**/*.html.erb")
    file_expand_path = File.expand_path('../../fixtures', __FILE__)
    files_orig = Dir.glob("#{file_expand_path}/**/*.xml")

    original_titles_to_file = files_orig.inject({}) do |result, file_orig|
      doc = Nokogiri::XML(File.read(file_orig))
      inner_html = doc.xpath('//Title').first.inner_html
      result.merge({strip_extension_starting_after('spec', file_orig) => inner_html})
    end

    files.each do |file|
      lines = File.readlines(file)
      expect(lines[0]).to eq "---\n"
      original_title = strip_extension_starting_after('spec', file)
      expect(lines[1]).to eq "title: #{original_titles_to_file[original_title]}\n"
      expect(lines[2]).to eq "---\n"
    end
  end

  def output_dir
    ENV['XYLEME_OUTPUT_DIR']
  end

  def convert(*arg)
    swallow_stderr do
      Rake::Task[:convert].reenable
      Rake::Task[:convert].invoke(*arg)
    end
  end

  def strip_extension_starting_after(split_on, file_path)
    file_path.split('.').first.split(split_on)[1]
  end

end

