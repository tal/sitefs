module Sitefs
  class RenderContext
    attr_reader :page_manager
    attr_accessor :current_page

    def initialize
      @page_manager = PageManager.new
    end

    def partial name
      dir = current_page && File.dirname(current_page.file_path)

      if dir
        ContentFile.new(dir, name, context: self).to_s
      end
    end

    def glob *args
      args.unshift current_page.file_path

      prefix = File.join(current_page.file_path, '')

      glob = File.join(*args)
      Dir[glob].map do |path|
        path.sub(prefix, '')
      end
    end

    def pages
      page_manager.pages.map {|p| p.view_model}
    end

    def title
      current_page && current_page.title
    end

    def tagged *tags, &blk
      page_manager.tagged(*tags).map {|p| p.view_model}.map(&blk)
    end
  end
end
