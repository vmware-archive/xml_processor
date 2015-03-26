require 'pp'
require 'fileutils'

exts = %w[jpg jpeg png]

artwork_dirs = Dir.glob('** artwork')
artwork_dirs.map {|dir| FileUtils.mv(dir, dir.gsub('artwork', '').strip) }

mentioned_images = exts.map do |ext|
  mentioned_pngs = Dir.glob('**/*.xml').map {|xml| File.read(xml).scan(/"([\S]+.#{ext})"/)}.flatten.uniq.sort.map {|imgpath|imgpath.gsub('01-RawContent/', '')}
end.flatten.uniq.sort

all_files = Dir.glob('**/*')
present_files = mentioned_images.select {|image| all_files.include?(image)}

remaining_files = mentioned_images - present_files
found_files = remaining_files.map do |file|
  matching_files = Dir.glob("**/*/#{File.basename(file)}")
  if matching_files.length == 1
    p "File #{file} found, but not where we expected. Copying it to the desired location."
    FileUtils.mkpath(File.dirname(file))
    FileUtils.copy_file(matching_files.first, file)
    file
  elsif matching_files.length > 1
    p "A file matching #{file} was found, but there is more than one match. We have used the first found."
    FileUtils.mkpath(File.dirname(file))
    FileUtils.copy_file(matching_files.first, file)
    file
  else
    p "File #{file} not found."
    nil
  end  
end.compact


present_files += found_files
remaining_files -= found_files

puts "\n"
p "We have: #{present_files.count} of #{mentioned_images.count} image files."

puts "\n"
p "We need the following files: "
pp remaining_files



