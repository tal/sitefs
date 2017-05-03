class Sitefs::AttributeSet
  include Enumerable

  KEY_ALIASES = {
    'published_at' => 'published',
  }

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

  def initialize setup = {}
    @attributes = {
      'tags' => [],
    }

    setup.each do |key, val|
      self[key] = val
    end
  end

  def normalize_key key
    k = key.to_s
    KEY_ALIASES[k] || k
  end

  def [] key
    @attributes[normalize_key(key)]
  end

  def []= key, value
    key = normalize_key(key)

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
      return new if lines.empty?

      if lines.is_a? Array
        lines = lines.join
      end

      data = YAML.load(lines)

      unless data
        STDERR.puts "Error loading yaml attributes from: #{lines.inspect}"
        data = {} # so it doesnt error further down
      end

      new(data)
    end

  end
end



