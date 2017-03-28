class Sitefs::Handler
  attr_reader :root_path, :source_file

  def initialize root_path, source_file
    @root_path = root_path
    @source_file = source_file
  end

  def should_generate? config
    true
  end

  def delay_generation
    false
  end

  def pages
    []
  end

  def path_helper
    @path_helper ||= PathHelper.new(root_path, source_file)
  end

  def file_actions registry
    []
  end

  def tags
    []
  end

  def html_pipeline_result
    @html_pipeline_result ||= {}
  end

  def attributes
    @attributes ||= AttributeSet.new.tap do |attrs|
      attrs['tags'] ||= tags
      attrs['title'] ||= html_pipeline_result[:title]
      attrs['subtitle'] ||= html_pipeline_result[:subtitle]
      attrs['description'] ||= html_pipeline_result[:subtitle]
    end
  end

end
