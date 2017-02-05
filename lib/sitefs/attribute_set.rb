class Sitefs::AttributeSet
  include Enumerable

  KEY_PARSERS = {
    'published' => -> (value) do
      if value.respond_to? :to_time
        value.to_time
      elsif value.is_a? Time
        value
      else
        Time.new(value)
      end
    end,
    'tags' => -> (value) do
      if value.is_a?(String)
        value.split(',')
      else
        value.to_a
      end.map(&:strip)
    end,
  }

  def initialize
    @attributes = {}
  end

  def [] key
    @attributes[key.to_s]
  end

  def []= key, value
    key = key.to_s

    if parser = KEY_PARSERS[key]
      @attributes[key] = parser.call(value)
    else
      @attributes[key] = value
    end
  end

  def each
    @attributes.each do |key, attr|
      yield key, attr.value
    end
  end

  def method_missing(meth, *args, &blk)
    method_name = meth.to_s

    if @attributes[method_name] && args.empty?
      self[method_name]
    elsif method_name[-1] == '=' && args.length == 1
      self[method_name[0...-1]] = args[0]
    else
      super
    end
  end

  class << self

    def from_yaml lines
      if lines.is_a? Array
        lines = lines.join
      end

      data = YAML.load(lines)

      unless data
        STDERR.puts "Error loading yaml attributes from: #{lines.inspect}"
        data = {} # so it doesnt error further down
      end

      set = new

      data.each do |key, val|
        set[key] = val
      end

      set
    end

  end
end



