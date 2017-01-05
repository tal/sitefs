# Class used for walking a source directory and discovering what files need to be mapped
class Sitefs::Walker
  attr_reader :root_path

  HANDLERS = {
    'page.{md,markdown}' => Handlers::Markdown,
    'page.rb' => Handlers::RubyGen,
    'page.*erb' => Handlers::SingleErb,
    'tag-page.rb' => Handlers::TagPage,
    'scss' => Handlers::Scss,
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

        reg << handler if handler.should_generate?
      end
    end

    reg
  end

  def file_matches? file
    HANDLERS.each do |ext, klass|
      globber = File.join(root_path, '**', "*.#{ext}")

      # File.fnmatch("foo*", "food")
      return true if Dir.glob(globber, File::FNM_CASEFOLD).include? file
    end

    return false
  end

end
