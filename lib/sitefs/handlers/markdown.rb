class Sitefs::Handlers::Markdown < Sitefs::Handler
  def output_path
    @source_file.sub(/\.page.*$/, '.html').sub(root_path, '')
  end

  def path
    File.join('', @source_file.gsub(/\.page.*$/, '').sub(@root_path, ''))
  end

  def config_strings
    _read unless @config_strings
    @config_strings
  end

  def markdown
    _read unless @markdown
    @markdown.join
  end

  MARKER_REG = /^\-{3,}$/

  def _read
    @config_strings = []
    @markdown = []

    in_config = false

    File.open(@source_file).each_with_index do |line, i|
      if i === 0 && line =~ MARKER_REG
        in_config = true
        next
      end

      if in_config
        if line =~ MARKER_REG
          in_config = false
          next
        else
          @config_strings << line
        end
      else
        @markdown << line
      end
    end
  end

  def attributes
    @attributes ||= AttributeSet.from_yaml(config_strings.join).tap do |attrs|
      attrs['tags'] ||= []
      attrs['title'] ||= html_pipeline_result[:title]
      attrs['subtitle'] ||= html_pipeline_result[:subtitle]
      attrs['description'] ||= html_pipeline_result[:subtitle]
     end
  end

  def pages
    @pages ||= begin
      page = Page.new(path_helper, attributes)
      page.path = path
      [page]
    end
  end

  def html_pipeline_result
    @html_pipeline_result ||= HtmlPipelines.markdown.call(markdown)
  end

  def xml
    html_pipeline_result[:output]
  end

  def output
    xml.to_s
  end

  def markdown_pipeline
    @markdown_pipeline ||= RendererPipeline.for(
      root_path: root_path,
      source_file: source_file,
      content_text: output,
      layout_name: '_layout.md.html.erb',
    )
  end

  def render_pipleine
    @render_pipleine ||= RendererPipeline.for(root_path: root_path, source_file: source_file, content_text: markdown_pipeline)
  end

  def _render context=nil
    render_pipleine.render(context)
  end

  def file_actions registry
    return [] unless page = pages.first

    FileAction.new path: output_path do
      context = RenderContext.new(registry, current_page: page)
      _render(context)
    end
  end

end
