require 'cgi'

module Sitefs::ViewModels
  class Page
    def initialize handler
      @handler = handler
    end

    def title
      @handler.content.title
    end

    def escaped_body
      CGI.escapeHTML @handler.content.to_s
    end

    def link klass: []
      %[<a href="#{href}" class="#{klass.join(' ')}">#{title}</a>]
    end

    def method_missing name, *args, &blk
      @handler.send(name, *args, &blk)
    end
  end
end
