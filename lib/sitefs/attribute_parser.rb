class Sitefs::AttributeParser
  attr_reader :key

  KEY_PARSERS = {
    'published' => -> (value) { Time.new(value) }
  }

  def initialize(attribute_string = nil, key: nil, raw_value: nil)
    if attribute_string
      mtch = attribute_string.match(/@?(?<key>\w+)(?:\((?<value>.+?)\))?/)

      @key = mtch['key']
      @raw_value = mtch['value']
    elsif key && raw_value
      @key = key

      if raw_value.is_a?(String)
        @raw_value = raw_value
      else
        @value = raw_value
      end
    else
      raise 'invalid arguments'
    end
  end

  def value
    return @value if defined?(@value)

    @value = if parser = KEY_PARSERS[key]
      parser.call(@raw_value)
    elsif @raw_value.nil? || @raw_value == 'true'
      true
    elsif @raw_value == 'false'
      false
    else
      @raw_value
    end
  end

  class << self
    def from_str str
      if str.start_with?('@')
        new str
      end
    end
  end
end
