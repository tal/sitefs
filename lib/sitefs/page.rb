class Sitefs::Page
  class << self
    def attribute_key *keys
      keys.each do |key|
        define_method(key) { attributes[key.to_s] }
        define_method("#{key}=") { |v| attributes[key.to_s] = v }
      end
    end
  end

  attr_accessor :path, :attributes
  attribute_key :title, :subtitle, :description, :tags, :published_at
  attr_accessor :_rendering_template

  def initialize path_helper, attributes = nil
    @attributes = attributes
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
