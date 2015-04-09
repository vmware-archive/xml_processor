class ReplaceWordsInText
  def initialize(replace_pairs)
    @replace_pairs = replace_pairs
  end

  def call(files)
    files.reduce({}) do |output, (file_path, text)|
      transformed_data = @replace_pairs.reduce(text) { |str, (k,v)| str.gsub(k,v) }
      output.merge({file_path => transformed_data})
    end
  end

end
