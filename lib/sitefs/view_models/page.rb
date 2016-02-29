module Sitefs::ViewModels
  class Page
    def initialize handler
      @handler = handler
    end

    def title
      @handler.content.title
    end

    def href
      @handler.href
    end

    def link klass: []
      %[<a href="#{href}" class="#{klass.join(' ')}">#{title}</a>]
    end
  end
end
