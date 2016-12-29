# Class used for walking a source directory and discovering what files need to be mapped
class Sitefs::Walker
  attr_reader :root_path

  HANDLERS = {
    'page.{md,markdown}' => Handlers::Markdown,
    'page.rb' => Handlers::RubyGen,
    'tag-page.rb' => Handlers::TagPage,
  }

  def initialize root_path
    # Ensure the source always has a trailing slash
    @root_path = File.join(root_path, '')
  end

  def walk
    reg = FileRegistry.new

    Dir.chdir @root_path

    HANDLERS.each do |ext, klass|
      globber = File.join(root_path, '**', "*.#{ext}")

      Dir.glob(globber, File::FNM_CASEFOLD).each do |file|
        handler = klass.new(@root_path, file)

        reg << handler
      end
    end

    reg
  end

end
