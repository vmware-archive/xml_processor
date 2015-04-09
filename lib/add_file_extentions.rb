class AddFileExtentions
  def initialize(file_extensions)
    @file_extensions = file_extensions
  end

  def call(files)
    files.reduce({}) do |output, (file_path, text)|
      output.merge(
          { @file_extensions.reduce(file_path) { |value, ext| value + '.' + ext } => text }
      )
    end
  end
end
