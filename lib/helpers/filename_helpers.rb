def is_xml_file?(filepath)
  File.file?(filepath) && filepath.split('.').last == 'xml'
end

def is_non_xml_file?(filepath)
  File.file?(filepath) && filepath.split('.').last != 'xml'
end