class WriteToFile
  def initialize(output_dir)
    @output_dir = output_dir
  end

  def call(files)
    FileUtils.mkdir_p(@output_dir)

    files.each do |filepath, file_content|
      base_path = Pathname(filepath).dirname
      FileUtils.mkdir_p("#{@output_dir}/#{base_path}")
      File.open("#{@output_dir}/#{filepath}", 'w+') { |file| file.write(file_content) }
    end

    files
  end
end

