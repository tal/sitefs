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

  def pages_tagged tag_str, all: false
    # If it hasnt been published always sort by the same
    default_time = Time.now

    pages.select do |page|
      is_tagged = page.tags.include? tag_str

      if all
        is_tagged
      else
        is_tagged && page.published_at
      end
    end.sort_by do |page|
      [page.published_at || default_time, page.title]
    end
  end

  def public_tags
    pages.flat_map(&:public_tags).uniq
  end

  def gather_actions
    all_handlers = handlers + delayed_handlers

    actions = all_handlers.flat_map do |handler|
      handler.file_actions self
    end

    FileActionSet.new(actions)
  end
end
