require 'sass'

class Sitefs::Handlers::Scss < Sitefs::Handler

  def content
    engine.render
  end

  def engine_options
    {
      cache: true,
      syntax: :scss,
      style: :compressed,
      filename: source_file,
      sourcemap: :inline,
      load_paths: [root_path],
    }
  end

  def engine
    @engine ||= Sass::Engine.new(File.read(source_file), engine_options)
  end

  def render_with_sourcemap
    @render_with_sourcemap ||= engine.render_with_sourcemap(sourcemap_output_pathname)
  end

  # def delay_generation
  #   true
  # end

  def should_generate? config
    File.basename(source_file)[0] != '_'
  end

  def output_path
    source_file.sub(/\.scss$/, '.css').sub(root_path, '')
  end

  def output_pathname
    File.join('', output_path)
  end

  def sourcemap_output_pathname
    output_pathname + '.map'
  end

  def sourcemap_output_path
    output_path + '.map'
  end

  def file_actions registry
    sourcemap_options = {
      css_path: output_path,
      sourcemap_path: sourcemap_output_path,
    }

    [
      FileAction.new(path: output_path) { render_with_sourcemap[0] },
      FileAction.new(path: sourcemap_output_path) { render_with_sourcemap[1].to_json(sourcemap_options) },
    ]
  end
end
