module Sitefs
  class RenderContext
    attr_reader :page_manager
    attr_accessor :current_page

    def initialize
      @page_manager = PageManager.new
    end

    def pages
      page_manager.pages.map {|p| p.view_model}
    end

    def title
      current_page && current_page.title
    end

    def tagged *tags, &blk
      page_manager.tagged(*tags).map {|p| p.view_model}.map(&blk)
    end
  end
end
