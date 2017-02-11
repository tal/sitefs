require 'digest/md5'
require 'fileutils'

class Sitefs::FileAction
  attr_reader :action, :path
  attr_accessor :render_error, :content_type

  def initialize action: :write, **args, &blk
    @action = action
    args.each do |k,v|
      instance_variable_set :"@#{k}", v
    end

    @content_type ||= content_type_for @path
    @tag_comment ||= comment_for_path @path

    @path = write_path_for @path

    if blk
      @content = blk
    end
  end

  GEN_FILE_TAG = 'gen by sitefs'
  def comment_for_path path
    case path
    when /\.html$/i
      "<!-- #{GEN_FILE_TAG} -->\n"
    when /\.(css|js)$/i
      "/* #{GEN_FILE_TAG} */\n"
    end
  end

  def content_type_for path
    case path
    when /\.html$/i
      'text/html'
    end
  end

  def content
    if @content.respond_to?(:call)
      @content = @content.call
    end

    unless @content_tag_added
      @content << @tag_comment if @tag_comment
      @content_tag_added = true
    end

    @content
  end

  def dirname
    File.dirname path
  end

  def content_hash
    @content_hash ||= Digest::MD5.hexdigest(content)
  end

  def destination_hash
    if File.exist? path
      @destination_hash ||= Digest::MD5.hexdigest(File.read(path))
    end
  end

  def should_write?
    !destination_hash || (content_hash != destination_hash)
  end

  def write_path_for path
    return path unless path =~ /\.html$/

    # god, global signletons are the worst, i'm sorry
    case CommandConfig.current.index_format
    when 'github', 'standard'
      path
    when 'all-index'
      if path =~ /index\.html$/i
        path
      else
        path.sub(/\.html$/, '/index.html')
      end
    when 'aws'
      if path =~ /index\.html$/i
        path
      else
        path.sub(/\.html$/, '/index.html')
      end
    end
  end

  def perform_action
    case action
    when :write
      if should_write?
        log :generate, path
        FileUtils.mkdir_p dirname
        File.open(path, 'w') { |file| file.write content }
      else
        log :identical, path
      end
    end
  end

  def log type, path
    puts "  #{type} - #{path}"
  end

  def to_s
    inspect
  end
end
