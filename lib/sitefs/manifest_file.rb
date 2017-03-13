class Sitefs::ManifestFile
  ALLOWED_KEYS = %i{generated_at uploaded_at uploaded_hash content_type}

  def initialize **attrs
    @attributes = attrs
  end

  def to_h
    ALLOWED_KEYS.inject({}) do |h, key|
      h[key] = @attributes[key] if @attributes[key]
      h
    end
  end

  def as_json *opts
    hsh = to_h
    if hsh.keys == [:content_type]
      nil
    else
      hsh
    end
  end

  def to_json *opts
    as_json(*opts).to_json(*opts)
  end

  def [] key
    raise ArgumentError.new('invalid key') unless ALLOWED_KEYS.include?(key)
    @attributes[key]
  end

  def []= key, value
    raise ArgumentError.new('invalid key') unless ALLOWED_KEYS.include?(key)

    if value.nil?
      @attributes.delete key
    else
      @attributes[key] = value
    end
  end

  class << self
    def ensure val
      if val.is_a?(self)
        return val
      elsif val.respond_to? :to_h
        return new(**val.to_h)
      else
        raise ArgumentError.new('can only convert hashes to ' + self.to_s)
      end
    end

    def from_file file
      content = File.read file
      raw = JSON.parse content, symbolize_names: true

      raw.inject({}) do |h, (k,v)|
        h[k] = new **v if k && v
        h
      end
    end
  end
end
