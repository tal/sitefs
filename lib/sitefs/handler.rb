class Sitefs::Handler
  attr_reader :root_path, :source_file

  def initialize root_path, source_file
    @root_path = root_path
    @source_file = source_file
  end

  def should_generate?
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
end
