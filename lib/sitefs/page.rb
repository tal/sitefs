class Sitefs::Page
  attr_accessor :url, :title, :subtitle, :description, :published_at, :tags, :attributes
  attr_accessor :_rendering_template

  def initialize
    @tags = []
  end

  def public_tags
    tags.select {|tag| !tag.start_with?('_')}
  end

  def attributes
    @attributes ||= AttributeSet.new
  end
end
