require 'tmpdir'
require_relative '../../../../lib/xml_processor/processes/xslt_transformer'

module XmlProcessor
  module Processes
    describe XsltTransformer do
      matcher :have_ids do
        match do |elements|
          elements.map {|h| h.attr('id') }.none?(&:nil?)
        end

        failure_message do |elements|
          "The following elements have nil ids:\n" +
              elements.select {|h| h.attr('id').nil?}.
                  map(&:to_xhtml).join("\n")
        end
      end

      matcher :be_html do
        match do |actual|
          actual.match(/\A<!DOCTYPE html/)
        end
      end

      matcher :have_no_spaces do
        whitespace_matcher = /\s|%20/

        match do |imgs|
          imgs.map {|i| i.attr('src')}.none? {|src| src.match(whitespace_matcher)}
        end

        failure_message do |imgs|
          "The following images have spaces in their src paths:\n" +
              imgs.select {|i| i.attr('src').match(whitespace_matcher)}.
                  map(&:to_xhtml).join("\n")
        end
      end

      def debug(html)
        tmp = Pathname(File.expand_path('../../../../../tmp', __FILE__))
        tmp.mkpath
        path = tmp.join('output.html')
        File.write(path, html)
        `open #{path}`
        puts html
      end

      context 'when given a valid input file' do
        it "returns a single hash of filenames to file contents" do
          processor = XsltTransformer.new(xslt_path, dest_extension: '.html')
          results = processor.call('file1.xml' => '<IA/>',
                                   'file2.xml' => '<IA/>')
          expect(results['file1.html']).to be_html
          expect(results['file2.html']).to be_html
        end

        let(:xslt_path) { File.open(File.expand_path('../../../../../lib/xml_processor/stylesheets/xyleme_to_html.xsl', __FILE__)) }
      end
    end
  end
end
