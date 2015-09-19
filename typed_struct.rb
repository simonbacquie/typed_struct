class TypedStruct

  @@types = {}
  @@required_attributes = []
  @@defined_attributes = []

  def initialize params
    create_getters(params.keys)
    create_setters(params.keys)
    @type_errors = []
    @requirement_errors = []

    raise ArgumentError, @requirement_errors.join(', ') unless valid_by_requirements?(params.keys)
    raise TypeError, @type_errors.join(', ') unless valid_by_types?(params)

    set_initial_values(params)
  end

  def create_getters attributes
    attributes.each do |a|
      self.instance_eval("def #{a};@attribute_#{a};end") if defined_attribute?(a)
    end
  end

  def create_setters attributes
    attributes.each do |a|
      self.instance_eval("def #{a}=(new_value);@attribute_#{a}=new_value;end") if defined_attribute?(a)
    end
  end

  def set_initial_values params
    params.keys.each do |p|
      instance_variable_set("@attribute_#{p}", params[p]) if defined_attribute?(p)
    end
  end

  def self.attribute name, klass, options=nil
    @@types[name] = klass
    @@required_attributes << name if options.is_a?(Hash) && options[:required]
    @@defined_attributes << name
  end

  def defined_attribute? attribute
    @@defined_attributes.include? attribute
  end

  def valid_by_requirements? attributes
    (@@required_attributes - attributes).each do |ra|
      @requirement_errors << "Attribute '#{ra}' is required"
    end

    return false if @requirement_errors.length > 0
    true
  end

  def valid_by_types? params
    params.keys.each do |p|
      if @@types[p] && @@types[p] != params[p].class
        @type_errors << "Attribute '#{p}' must be of type #{@@types[p].to_s}"
      end
    end

    return false if @type_errors.length > 0
    true
  end

end


class ImageMetadata < TypedStruct

  attribute :title,        String, required: true
  attribute :description,  String
  attribute :pixel_width,  Fixnum
  attribute :pixel_height, Fixnum
  attribute :dpi,          Fixnum
  attribute :taken_at,     Time,   required: true

end
