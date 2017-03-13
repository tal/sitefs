require "webrick"

class Sitefs::Servlet < WEBrick::HTTPServlet::FileHandler
  def initialize server, root, callbacks
    @sitefs_config = server.config[:SitefsConfig]
    super
  end

  def search_file(req, res, basename)
    case @sitefs_config.index_format
    when 'github', 'standard'
      # /file.* > /file/index.html > /file.html
      super || super(req, res, "#{basename}.html")
    else
      super
    end
  end

  def do_GET(req, res)
    rtn = super

    content_type = @sitefs_config.manifest.path_content_type res.filename
    res['content-type'] = content_type if content_type

    # Disable caching to make dev easier
    res['Cache-Control'] = "private, max-age=0, proxy-revalidate, " \
            "no-store, no-cache, must-revalidate"

    rtn
  end
end
