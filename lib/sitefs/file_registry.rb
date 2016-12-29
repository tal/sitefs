class Sitefs::FileRegistry

  def initialize
    @handlers = []
  end

  def << handler
    @pages = nil

    if handler.respond_to? :registry=
      handler.registry = self
    end

    @handlers << handler
  end

  def handlers
    @handlers.select {|h| !h.delay_generation }
  end

  def delayed_handlers
    @handlers.select {|h| h.delay_generation }
  end

  def pages
    @pages ||= handlers.flat_map do |h|
      h.pages
    end.compact
  end

  def pages_tagged tag_str
    pages.select do |page|
      page.tags.include? tag_str
    end
  end

  def public_tags
    pages.collect(&:public_tags).flatten.uniq
  end

  def gather_actions
    all_handlers = handlers + delayed_handlers

    actions = all_handlers.flat_map do |handler|
      handler.file_actions self
    end

    FileActionSet.new(actions)
  end
end
