class Sitefs::DslContext
  attr_reader :root_path, :source_file, :_pages_to_render
  def initialize root_path, source_file
    @source_file, @root_path = source_file, root_path
    @_pages_to_render = []
  end

  def _eval
    instance_eval(File.read(source_file), source_file)
    @_pages_to_render
  end

  def current_dir
    File.dirname(source_file)
  end

  def files_like matcher
    if matcher.is_a?(Regexp)
      Dir['**/*'].grep(matcher)
    else
      Dir.glob(File.join(current_dir, matcher), File::FNM_CASEFOLD)
    end
  end

  def render page, with:, **args
    page._rendering_template = with
    @_pages_to_render << page
  end
end
