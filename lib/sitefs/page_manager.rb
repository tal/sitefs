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

    def tagged *tags

      published = pages.select(&:published?)

      tags.reduce published do |pages, tag|
        pages.select do |page|
          page.tag_strs.include? tag
        end
      end.sort_by(&:published_at).reverse
    end
  end
end
