class Sitefs::RendererPipeline
  attr_reader :renderers

  def initialize *args
    @renderers = args
  end

  def << renderer
    if renderer.respond_to?(:renderers)
      renderer.renderers.each do |renderer|
        self << renderer
      end
    else
      @renderers << renderer
    end
  end

  def render context=nil
    renderers.reverse.reduce('') do |prev, renderer|
      renderer = ensure_renderer renderer

      result = renderer.render(context) do |arg=nil|
        if arg
          if context.respond_to?(:_get_content_for)
            value = context._get_content_for arg
          else
            value = "<!-- No context, so couldn't render content for #{arg} -->"
          end
        else
          value = prev
        end

        value
      end

      if result.hit_root?
        break result.to_s
      else
        next result.to_s
      end
    end
  end

  def ensure_renderer renderer
    if !renderer.respond_to?(:render)
      if renderer.is_a?(String)
        renderer = Renderer.new(renderer)
      else
        throw "#{renderer.inspect} is not a supported renderer"
      end
    end

    renderer
  end

  class << self
    def possible_files_for root_path:, source_file:, layout_name: '_layout.html.erb'
      root_path = File.join(root_path,'')

      files = []

      begin
        dir = File.join(File.dirname(source_file), '')

        look_at = File.join(dir, layout_name)

        if File.exist? look_at
          files << look_at
        end

        source_file = dir
      end until dir === root_path || root_path.length >= dir.length # safety to ensure the equality doesn't miss

      files
    end

    def for content_text: nil, **args
      layouts = possible_files_for **args

      layout_text = layouts.reverse.map do |layout_file|
        File.read(layout_file)
      end

      pipeline = new *layout_text

      if content_text
        pipeline << content_text
      end

      pipeline
    end
  end

end
