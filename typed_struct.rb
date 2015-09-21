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
      if defined_attribute?(a)
        evaled_code =  "def #{a}=(new_value);"
        evaled_code << "assignment_type_check(:#{a}, new_value);"
        evaled_code << "@attribute_#{a}=new_value;"
        evaled_code << "end"
        self.instance_eval(evaled_code)
      end
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

  def assignment_type_check attribute, new_value
    raise TypeError, type_error_message(attribute) if @@types[attribute] != new_value.class
  end

  def valid_by_requirements? attributes
    (@@required_attributes - attributes).each do |ra|
      @requirement_errors << requirement_error_message(ra)
    end

    return false if @requirement_errors.length > 0
    true
  end

  def valid_by_types? params
    params.keys.each do |p|
      if @@types[p] && @@types[p] != params[p].class
        @type_errors << type_error_message(p)
      end
    end

    return false if @type_errors.length > 0
    true
  end

  def type_error_message attribute
    "Attribute '#{attribute}' must be of type #{@@types[attribute].to_s}"
  end

  def requirement_error_message required_attribute
    "Attribute '#{required_attribute}' is required"
  end

end
