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
    source_file.sub(/\.page(\..*)?\.erb$/,'\1').sub(root_path, '')
  end

  def content_text
    @content_text ||= File.read(source_file)
  end

  def renderer
    RendererPipeline.for(root_path: root_path, source_file: source_file, content_text: content_text)
  end

  def pages
    @pages ||= begin
      page = Page.new path_helper, attributes
      page.href = path_helper.min_href_for output_path
      begin
        page.published_at = File.birthtime(source_file)
      rescue NotImplemenredError
      end
      [page]
    end
  end

  def page
    pages.first
  end

  def html_pipeline_result
    @html_pipeline_result ||= HtmlPipelines.content.call(content_text)
  end

  def file_actions registry
    FileAction.new path: output_path do
      context = RenderContext.new(registry, current_page: page)

      renderer.render context
    end
  end
end
