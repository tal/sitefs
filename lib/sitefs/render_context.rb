class Sitefs::RenderContext
  attr_reader :current_page

  def initialize(registry, current_page: nil)
    @registry, @current_page = registry, current_page

    @content_for = {}
  end

  def _set_content_for key, val
    @content_for[key] = val
  end

  def _get_content_for key
    @content_for[key]
  end

  def public_tags
    @registry ? @registry.public_tags : []
  end

  def pages_tagged tag_str, all: false
    @registry ? @registry.pages_tagged(tag_str, all: all) : []
  end

  class << self
    def nil
      @nil ||= new(nil)
    end
  end
end
