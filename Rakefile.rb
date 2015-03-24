task default: %w[convert]

task :convert, [:dir] do |t, args|
  extra_dirs_str = args.extras.inject {|accum, arg| accum + "#{arg.to_s }"}
  dirs = args[:dir]
  dirs += ' ' + extra_dirs_str unless extra_dirs_str.nil?

  ruby "main.rb #{dirs}"
end

task :show_output, [:file] do |t, args|
  file = args[:file] || "real_files/ambari.html"

  `open "./output/#{file}"`
end