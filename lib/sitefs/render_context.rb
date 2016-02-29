module Sitefs
  class RenderContext
    attr_reader :page_manager

    def initialize
      @page_manager = PageManager.new
    end

    def pages
      page_manager.pages.map {|p| ViewModels::Page.new(p)}
    end

    def tagged tag, &blk
      page_manager.tagged(tag).map {|p| ViewModels::Page.new(p)}.map(&blk)
    end

    def title
      'My Title!!'
    end
  end
end
