# To make sure that inside of the DSLs you can import yaml files
require 'yaml'

class Sitefs::DslContext
  attr_reader :_pages_to_render, :path_helper
  def initialize path_helper
    @path_helper = path_helper
    @_pages_to_render = []
  end

  def source_file
    @path_helper.source_file
  end

  def path_for_href href
    @path_helper.pathname_for href
  end

  def root_path
    @path_helper.root_path
  end

  def _eval
    instance_eval(File.read(source_file), source_file)
    @_pages_to_render
  end

  def current_dir
    File.dirname(source_file)
  end

  def files_like matcher
    if matcher.is_a?(Regexp)
      Dir[File.join(current_dir,'**/*')].grep(matcher)
    else
      Dir.glob(File.join(current_dir, matcher), File::FNM_CASEFOLD)
    end
  end

  def Page
    Page
  end

  def new_page
    Page.new path_helper
  end

  def render page, with:, **args
    page._rendering_template = @path_helper.full_path_for(with)
    @_pages_to_render << page
    page
  end
end
