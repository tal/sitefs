class Sitefs::PathHelper
  attr_reader :root_path, :source_file

  def initialize root_path, source_file
    @root_path = File.expand_path root_path
    @source_file = File.expand_path source_file, @root_path
  end

  def pathname
    source_file.sub(File.join(root_path, ''), '')
  end

  def pathname_for href
    return nil unless href

    dir = File.dirname source_file

    File.expand_path(href, dir).sub(root_path, '')
  end

  def min_href_for path
    return nil unless path

    dir = File.join(File.dirname(source_file), '')
    File.join(root_path, path, ).sub(dir, '').sub(root_path, '')
  end

  def full_path_for href
    File.join(root_path, pathname_for(href))
  end
end
