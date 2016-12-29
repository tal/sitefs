require 'cgi'

module Sitefs::ViewModels
  class Page
    def initialize handler
      @handler = handler
    end

    def escaped_body
      CGI.escapeHTML @handler.content.to_s
    end

    def link class_names: [], title:nil
      _title = title || @handler.title

      %[<a href="#{href}" class="#{class_names.join(' ')}">#{_title}</a>]
    end

    def method_missing name, *args, &blk
      @handler.send(name, *args, &blk)
    end
  end
end
