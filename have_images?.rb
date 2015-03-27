require 'pp'
require 'fileutils'

exts = %w[jpg jpeg png]

FileUtils.mkdir_p("01-RawContent")
artwork_dirs = Dir.glob('** artwork')
artwork_dirs.map { |dir| FileUtils.mv(dir, "01-RawContent/#{dir.gsub('artwork', '').strip}") }

# find all desired images
desired_images = exts.map do |ext|
  regex_for_image_references = /"([\S]+.#{ext})"/
  all_xml_files = Dir.glob('**/*.xml')

  referenced_images = all_xml_files.map do |xml|
    file_content = File.read(xml)
    file_content.scan(regex_for_image_references)
  end.flatten.uniq.sort
end.flatten.sort


all_files = Dir.glob('**/*')
present_images = desired_images.select {|image| all_files.include?(image)}

# search for missing images that might have different names
missing_images = desired_images - present_images
found_images = missing_images.map do |missing_img_path|
  img_name = File.basename(missing_img_path)
  matching_files = Dir.glob("**/*/#{img_name}")

  single_match_msg = "File #{missing_img_path} found, but not where we expected. Copying it to the desired location."
  multiple_match_msg = "A file matching #{missing_img_path} was found, but there is more than one match. We have used the first found."

  if matching_files.empty?
    nil
  elsif matching_files.length == 1
    puts single_match_msg
    matching_img = matching_files.first
    FileUtils.mkpath(File.dirname(missing_img_path))
    FileUtils.copy_file(matching_img, missing_img_path)
    missing_img_path
  else
    puts multiple_match_msg
    matching_img = matching_files.first
    FileUtils.mkpath(File.dirname(missing_img_path))
    FileUtils.copy_file(matching_img, missing_img_path)
    missing_img_path
  end

end.compact

puts "No files were copied in this run." if found_images.empty?

present_images += found_images
missing_images -= found_images

puts "\nWe have: #{present_images.count} of #{desired_images.count} image files."
puts "\nWe need the following #{missing_images.count} files: "
missing_images.each {|file| puts "\t#{file}\n"}



