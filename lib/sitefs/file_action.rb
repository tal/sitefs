require 'digest/md5'
require 'fileutils'
require 'diffy'
require 'mime/types'

Diffy::Diff.default_format = :color

MAP_MIME_TYPE = MIME::Type.new('application/json+sourcemap') {|type| type.add_extensions('map')}
MIME::Types.add(MAP_MIME_TYPE)

class Sitefs::FileAction
  attr_accessor :render_error, :content_type, :path

  POSSIBLE_ACTIONS = %i{upload write}

  def initialize possible_actions: POSSIBLE_ACTIONS, path:, content: nil, content_type: nil, &blk
    @content_type = content_type || content_type_for(path)
    @possible_actions = possible_actions
    @path = path

    @content = blk || content
  end

  def content_type_for path
    unless mtype = MIME::Types.type_for(path).first
      return
    end

    type = mtype.to_s
    case mtype
    when 'text/html', 'application/javascript'
      type += '; charset=utf-8'
    when MAP_MIME_TYPE
      type = 'application/json'
    end

    type
  end

  def content_causes_error?
    begin
      content
      nil
    rescue => error
      error
    end
  end

  def content
    if @content.respond_to?(:call)
      @content = @content.call
    end

    @content
  end

  def content_hash
    @content_hash ||= Digest::MD5.hexdigest(content)
  end

  def destination_hash config, action, path
    case action
    when :write
      if File.exist? path
        Digest::MD5.hexdigest(File.read(path))
      end
    when :upload
      if manifest = config.manifest.path_uploaded_hash(path)
        manifest
      elsif obj = config.s3_object(path)
        obj.etag[1...-1]
      end
    end
  end

  # TODO: make this return a reason instead of bool
  def should_write? config, action, path
    return true if config.force?

    d_hash = destination_hash(config, action, path)

    result = !d_hash || (content_hash != d_hash)
    if result && false
      puts "should_write? #{path}"
      puts "  dest hash: #{d_hash}"
      puts "  cont hash: #{content_hash}"

      remote_content = config.s3_object_contents(path)

      diff = Diffy::Diff.new(remote_content, content)
      puts "  #{diff.to_s}"
    end

    result
  end

  def write_path_for path, config
    return path unless path =~ /\.html$/

    case config.index_format
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
        path.sub(/\.html$/, '')
      end
    end
  end

  def perform_action config, action
    unless POSSIBLE_ACTIONS.include? action
      raise ArgumentError.new("invalid action: #{action}")
    end

    unless @possible_actions.include? action
      return
    end

    path = write_path_for @path, config

    dirname = File.dirname path

    config.manifest.set_path_content_type path, content_type if content_type

    case action
    when :write
      if error = content_causes_error?
        log :exception, path
        puts error.message
        puts error.backtrace
      elsif should_write? config, action, path
        log :generate, path
        FileUtils.mkdir_p dirname
        File.open(path, 'w') { |file| file.write content }

        config.manifest.generated_path path
      else
        log :identical, path
      end
    when :upload
      if should_write? config, action, path
        log :upload, path

        config.put_s3_object path, content_type: content_type, body: content
        config.manifest.uploaded_path path
        config.manifest.set_path_uploaded_hash path, content_hash
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
