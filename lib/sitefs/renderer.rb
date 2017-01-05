require 'erb'

module Sitefs
  class Renderer
    attr_reader :context
    attr_accessor :layout_type

    def initialize content
      @erb = ERB.new(content, nil, nil, '@_out_buf')
      @layout_type = LayoutType.default
      @content_for = {}
    end

    def is_root!
      @layout_type = LayoutType.root

      if @context.respond_to? :hit_root!
        @context.hit_root!
      end
    end

    def is_root?
      @layout_type == LayoutType.root
    end

    def render context = nil
      @context = context
      __result = @erb.result(binding)
      @context = nil

      RenderResult.new(text: __result, layout_type: @layout_type)
    end

    def content_for key, &block
      @_out_buf, _buf_was = '', @_out_buf
      block.call
      result = eval('@_out_buf', block.binding)
      @_out_buf = _buf_was

      @context._set_content_for key, (result.strip)
    end

    def to_s
      render
    end

    def title
      current_page && current_page.title
    end

    def method_missing name, *args, &blk
      if context.respond_to? name
        context.send(name, *args, &blk)
      elsif RenderContext.nil.respond_to? name
        RenderContext.nil.send(name, *args, &blk)
      else
        raise "Rendering context respond to #{name}"
      end
    end
  end
end
