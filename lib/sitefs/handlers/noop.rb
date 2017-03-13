class Sitefs::Handlers::Noop < Sitefs::Handler
  def output_path
    @source_file.sub(root_path, '')
  end

  def should_generate? config
    (File.basename(source_file)[0] != '_') && !config.manifest.generated?(output_path)
  end

  def file_actions registry
    FileAction.new(path: output_path, possible_actions: %i{upload}) do
      File.read(@source_file)
    end
  end
end
