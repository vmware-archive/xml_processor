require_relative '../../../../lib/xml_processor/processes/add_frontmatter'

module XmlProcessor
  module Processes
    describe AddFrontmatter do
      it 'adds a frontmatter to the file content string' do
        file_hash = {
          'dir1/file1' => '<html><body>Hey this is some content</body></html>',
          'dir2/file2' => '<html><body>There aint no head tag up in here</body></html>'
        }
        file_hash_with_frontmatter = add_frontmatter.call(file_hash)

        expect(file_hash_with_frontmatter['dir1/file1']).to match /---\n(.*)\n---/
        expect(file_hash_with_frontmatter['dir2/file2']).to match /---\n(.*)\n---/
      end

      context 'if title exists in the HTML head' do
        it 'adds the title to the frontmatter' do
          file_hash = {
            'dir1/file1' => '<html><head><meta><title>What</title></meta></head></html>',
            'dir2/file2' => '<html><head><meta><title>Hadoop!</title></meta></head></html>'
          }
          file_hash_with_frontmatter = add_frontmatter.call(file_hash)

          expect(file_hash_with_frontmatter['dir1/file1']).to match /---\ntitle: What\n---/
          expect(file_hash_with_frontmatter['dir2/file2']).to match /---\ntitle: Hadoop!\n---/
        end
      end

      context 'if no title exists in the HTML head' do
        it 'adds a default title to the frontmatter' do
          file_hash = {
            'dir1/file1' => '<html><head><meta>Sorry no title</meta></head></html>',
            'dir2/file2' => '<html><head><meta>No title here</meta></head></html>'
          }
          file_hash_with_frontmatter = add_frontmatter.call(file_hash)

          expect(file_hash_with_frontmatter['dir1/file1']).to match /---\ntitle: Nice Default Title\n---/
          expect(file_hash_with_frontmatter['dir2/file2']).to match /---\ntitle: Nice Default Title\n---/
        end
      end

      context 'if the title in the HTML head is blank' do
        it 'adds a default title to the frontmatter' do
          file_hash = {
            'dir1/file1' => '<html><head><meta><title></title></meta></head></html>',
            'dir2/file2' => '<html><head><meta><title></title></meta></head></html>'
          }
          file_hash_with_frontmatter = add_frontmatter.call(file_hash)

          expect(file_hash_with_frontmatter['dir1/file1']).to match /---\ntitle: Nice Default Title\n---/
          expect(file_hash_with_frontmatter['dir2/file2']).to match /---\ntitle: Nice Default Title\n---/
        end
      end

      def add_frontmatter
        AddFrontmatter.new('Nice Default Title')
      end
    end
  end
end

