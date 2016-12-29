require 'digest/md5'

class Sitefs::FileAction
  attr_reader :action, :path

  def initialize action: :write, **args, &blk
    @action = action
    args.each do |k,v|
      instance_variable_set :"@#{k}", v
    end

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

  def perform_action
    case action
    when :write
      File.open(path, "w") { |file| file.write content } if should_write?
    end
  end

  def to_s
    inspect
  end
end
