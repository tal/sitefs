class Sitefs::AttributeSet
  include Enumerable

  def initialize(attributes = {})
    @attributes = {}

    attributes.each {|attr| add_attribute attr}
  end

  def add_attribute attribute
    if !attribute.is_a?(AttributeParser)
      attribute = AttributeParser.from_str(attribute)
    end

    attribute && @attributes[attribute.key] = attribute
  end

  def [] key
    attr = @attributes[key.to_s]

    attr && attr.value
  end

  def []= key, value
    attr = AttributeParser.new(key: key, raw_value: value)
    @attributes[key] = attr
    attr.value
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
end
