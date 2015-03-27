require_relative 'lib/locate_images'

ARGV.each do |arg|
  FileUtils.remove_dir('image_workspace', true)
  target = 'image_workspace'
  FileUtils.cp_r arg, target

  image_locator = LocateImages.new

  incorrectly_referenced = image_locator.incorrectly_referenced_images(target).reject(&:empty?)
  puts "\nThe following images (#{incorrectly_referenced.length}) were not referenced correctly:"
  incorrectly_referenced.each {|file| puts "\t#{file}\n"}

  unrecoverable_images = image_locator.find_unrecoverable_images(target).reject(&:empty?)
  puts "\nThe following images (#{unrecoverable_images.length}) were unrecoverable:"
  unrecoverable_images.each {|file| puts "\t#{file}\n"}

  recovered_images = incorrectly_referenced - unrecoverable_images
  puts "\nThe recovered images (#{recovered_images.length}):"
  recovered_images.each {|file| puts "\t#{file}\n"}

  image_locator.copy_missing_images(target)

end
