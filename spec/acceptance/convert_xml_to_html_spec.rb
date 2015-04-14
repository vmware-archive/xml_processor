require 'rake'
Rake.load_rakefile(File.expand_path('../../../Rakefile', __FILE__))

describe 'converting any XML files to HTML' do
  it 'an exception when encountering malformed XML' do
    require_relative '../../lib/xml_processor/exceptions'
    expect { convert('spec/fixtures/invalid_xml_files') }.
        to raise_exception(XmlProcessor::InvalidXML)
  end

  def convert(*args)
    Rake::Task[:convert].execute(args)
  end
end
