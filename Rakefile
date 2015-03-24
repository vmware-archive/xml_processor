task default: %w[build]

task :build, [:dir] do |t, args|

end

task :convert, [:dir] do |t, args|
  extra_dirs_str = args.extras.inject {|accum, arg| accum + "#{arg.to_s }"}
  dirs = args[:dir] + ' ' + extra_dirs_str

  ruby "main.rb #{dirs}"
end

task :show_output, [:file] do |t, args|
  file = args[:file] || "real_files/ambari.html"

  `open "./output/#{file}"`
end