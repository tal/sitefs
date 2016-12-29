require 'erb'

module Sitefs
  class Renderer
    attr_reader :context

    def initialize content
      @erb = ERB.new(content)
    end

    def render context = nil
      @context = context
      __result = @erb.result(binding)
      @context = nil
      __result
    end

    def method_missing name, *args, &blk
      if context.respond_to? name
        context.send(name, *args, &blk)
      else
        raise "Rendering context respond to #{name}"
      end
    end
  end
end
