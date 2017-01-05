class Sitefs::Handlers::SingleErb < Sitefs::Handler
  def basename
    File.basename(source_file)
  end

  def extension
    if match = basename.match(/\.page(\..*)?\.erb$/)
      match[1]
    else
      '.html'
    end
  end

  def output_path
    source_file.sub(/\.page(\..*)?\.erb$/,'\1')
  end

  def renderer
    content_text = File.read(source_file)
    RendererPipeline.for(root_path: root_path, source_file: source_file, content_text: content_text)
  end

  def pages
    @pages ||= begin
      page = Page.new path_helper
      page.tags << '_single'
      [page]
    end
  end

  def page
    pages.first
  end

  def file_actions registry
    pages.map do |page|
      FileAction.new path: output_path do
        context = RenderContext.new(registry, current_page: page)

        renderer.render context
      end
    end
  end
end
