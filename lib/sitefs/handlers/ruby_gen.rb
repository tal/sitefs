class Sitefs::Handlers::RubyGen < Sitefs::Handler
  def dsl
    @dsl ||= DslContext.new path_helper
  end

  def pages
    @pages ||= begin
      dsl._eval
    end
  end

  def renderer_for page
    content_path = page._rendering_template
    content_text = File.read(content_path)

    RendererPipeline.for(root_path: root_path, source_file: source_file, content_text: content_text)
  end

  def file_actions registry
    pages.map do |page|
      output_path = page.expanded_path + '.html'

      FileAction.new path: output_path do
        renderer = renderer_for page
        context = RenderContext.new(registry, current_page: page)

        renderer.render context
      end
    end
  end

end
