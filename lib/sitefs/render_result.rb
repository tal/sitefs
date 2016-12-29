module Sitefs
  class RenderResult
    attr_reader :text
    def initialize text:, layout_type: LayoutType.default
      @text, @layout_type = text, layout_type
    end

    def hit_root?
      @layout_type == LayoutType.root
    end

    def to_s
      text
    end
  end
end
