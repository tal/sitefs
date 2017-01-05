class Sitefs::Page
  attr_accessor :path, :title, :subtitle, :description, :published_at, :tags, :attributes
  attr_accessor :_rendering_template

  def initialize path_helper
    @path_helper = path_helper
    @tags = []
  end

  def public_tags
    tags.select {|tag| !tag.start_with?('_')}
  end

  def href
    @path_helper.min_href_for @path
  end

  def href= href
    @path = @path_helper.pathname_for href
  end

  def expanded_path
    File.join(@path_helper.root_path, path)
  end

  def attributes
    @attributes ||= AttributeSet.new
  end

  def [] key
    attributes[key]
  end
end
