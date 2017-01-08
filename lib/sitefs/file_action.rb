require 'digest/md5'
require 'fileutils'

class Sitefs::FileAction
  attr_reader :action, :path
  attr_accessor :render_error

  def initialize action: :write, **args, &blk
    @action = action
    args.each do |k,v|
      instance_variable_set :"@#{k}", v
    end

    @path = write_path_for @path

    if blk
      @content = blk
    end
  end

  def content
    if @content.respond_to?(:call)
      @content = @content.call
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

    if path =~ /index\.html$/i
      path
    else
      path.sub(/\.html$/, '/index.html')
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
