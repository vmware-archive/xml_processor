require 'rake'
require_relative '../helpers/output'
require_relative '../../lib/pusher'
require_relative '../../lib/xml_processor/converter'

class ApplicationRunner
  def initialize(github_client, transformed_data_dir, push_context)
    @github_client = github_client
    @transformed_data_dir = transformed_data_dir
    @push_context = push_context
  end

  def convert_directories(directories)
    XmlProcessor::Converter.new(Pathname.new(@transformed_data_dir).join('output')).run(directories)
  end

  def push_to_remote(remote)
    Pusher.new(@github_client, Pathname.new(@push_context)).
      run(remote, Pathname(@transformed_data_dir).join('output'))
  end
end
