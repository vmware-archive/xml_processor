require_relative '../../lib/locate_images'

describe LocateImages do
  it 'copies images that are not referenced correctly but are still present' do
    Dir.mktmpdir do |tmpdir|
      dir = 'spec/fixtures/locate_images_test_files'
      dirpath = File.expand_path('.', dir)
      FileUtils.cp_r dirpath, tmpdir

      dir_to_search = File.join(tmpdir, 'locate_images_test_files')
      desired_uri = "#{tmpdir}/locate_images_test_files/a_misnamed_img_dir/image_3.png"

      expect(File.exist?(desired_uri)).to be false

      image_locator.copy_missing_images(dir_to_search)

      expect(File.exist?(desired_uri)).to be true
    end
  end

  it 'returns a list of the absent .jpg, .jpeg, .png, .tif, .tiff, and .emf images' do
    xmls_missing_images = 'spec/fixtures/locate_images_test_files'
    absent_images = image_locator.find_unrecoverable_images(xmls_missing_images)
    expect(absent_images).to match_array ['icons/note.png',
                                          'image directory/image_2.png',
                                          'images/img_6.jpeg',
                                          'icons/img_1.tif',
                                          'image directory/img_3.tiff',
                                          'images/img_4.emf'
                                         ]
  end

  def image_locator
    LocateImages.new
  end
end
