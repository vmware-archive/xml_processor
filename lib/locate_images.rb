require 'fileutils'
require 'nokogiri'

class LocateImages

  SUPPORTED_EXTS = %w[jpg jpeg png tif tiff emf]

  def copy_missing_images(dir)
    missing_images = incorrectly_referenced_images(dir)
    found_image_paths = matching_image_for(missing_images, dir)
    found_image_paths.each do |desired_uri, found_dir|
      desired_dir = "#{dir}/#{desired_uri}"
      copy_image_to_correct_uri(found_dir, desired_dir)
    end
  end

  def incorrectly_referenced_images(dir)
    referenced_images = image_paths(dir)

    all_images = all_images(dir)
    present_images = referenced_images.select do |desired_img_path|
      all_images.any? {|image| image.include? desired_img_path }
    end

    referenced_images - present_images
  end

  def find_unrecoverable_images(dir)
    referenced_images = image_paths(dir)

    all_images = all_images(dir)
    image_names = all_images.map {|image_path| File.basename(image_path) }
    present_images = referenced_images.select do |desired_img_path|
      image_names.include? File.basename(desired_img_path)
    end

    referenced_images - present_images
  end

  private

  def image_paths(dir)
    dirpath = File.expand_path('.', dir)
    xml_files = Dir.glob("#{dirpath}/**/*.xml")

    xml_files.map do |xml_file|
      doc = Nokogiri::XML(File.read(xml_file))
      doc.xpath("//*[@uri]").map { |elm| elm.attr('uri') }
    end.flatten.uniq.sort
  end

  def matching_image_for(img_paths, dir)
    img_paths.reduce({}) do |mapping, img_path|
      missing_img = File.basename(img_path)
      matched_image_uris = all_images(dir).select { |image| File.basename(image) == missing_img }
      mapping.merge({img_path => matched_image_uris.first})
    end.reject { |_, value| value.nil?}
  end

  def copy_image_to_correct_uri(found_uri, desired_uri)
    FileUtils.mkdir_p(File.dirname(desired_uri))
    FileUtils.cp(found_uri, desired_uri)
  end

  def all_images(dir)
    dirpath = File.expand_path('.', dir)
    all_images = SUPPORTED_EXTS.map do |ext|
      Dir.glob("#{dirpath}/**/*.#{ext}")
    end
    all_images.flatten
  end

end
