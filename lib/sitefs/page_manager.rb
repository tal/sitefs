module Sitefs
  class PageManager
    attr_reader :pages

    def initialize pages = []
      @pages = pages
    end

    def tags
      tags = Set.new

      pages.each do |page|
        tags.merge page.tag_strs
      end

      tags
    end

    def tagged tag
      pages.select do |page|
        page.tag_strs.include? tag
      end
    end
  end
end
