class Sitefs::Handler
  attr_reader :root_path, :source_file

  def initialize root_path, source_file
    @root_path = root_path
    @source_file = source_file
  end

  def delay_generation
    false
  end

  def pages
    []
  end
end
