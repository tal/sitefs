require 'sass'

class Sitefs::Handlers::Scss < Sitefs::Handler

  def content
    options = {
      cache: true,
      syntax: :scss,
      style: :compressed,
      filename: source_file,
    }

    Sass::Engine.new(File.read(source_file), options).render
  end

  # def delay_generation
  #   true
  # end

  def should_generate?
    File.basename(source_file)[0] != '_'
  end

  def output_path
    source_file.sub(/\.scss$/, '.css')
  end

  def file_actions registry
    FileAction.new path: output_path do
      content
    end
  end
end
