module Reposition
  # Repositions an object between two other objects based on a given attribute.
  #
  # @param object [Object] The object to reposition.
  # @param preceding_object [Object] The object that comes before the object to reposition.
  # @param following_object [Object] The object that comes after the object to reposition.
  # @param attribute_name [Symbol] The name of the attribute to use for repositioning.
  # @param options [Hash] Additional options for saving the object.
  #   - :validate [Boolean] Whether to validate the object before saving. Default is true.
  #   - :save [string] Options are save and save!. The default is not to save.
  #
  # @return [Object] The repositioned object.

  def self.reposition!(object:, preceding_object:, following_object:, attribute_name:, options: { validate: true })
    reposition(object: object, preceding_object: preceding_object, following_object: following_object, attribute_name: attribute_name, options: options.merge(save: 'save!'))
  end

  def self.reposition(object:, preceding_object:, following_object:, attribute_name:, options: { validate: true, save: nil })
    validate_arguments(object, preceding_object, following_object, attribute_name)

    if preceding_object.nil?
      object.update_attribute(attribute_name, following_object.send(attribute_name) - 1)
    elsif following_object.nil?
      object.update_attribute(attribute_name, preceding_object.send(attribute_name) + 1)
    else
      object.update_attribute(attribute_name, (preceding_object.send(attribute_name) + following_object.send(attribute_name)) / 2)
    end

    save_object(object, options)

    object
  end

  private

  # Validates the arguments for the reposition method.
  #
  # @param object [Object] The object to reposition.
  # @param preceding_object [Object] The object that comes before the object to reposition.
  # @param following_object [Object] The object that comes after the object to reposition.
  # @param attribute_name [Symbol] The name of the attribute to use for repositioning.
  #
  # @raise [ArgumentError] If any of the arguments are invalid.
  def self.validate_arguments(object, preceding_object, following_object, attribute_name)
    raise ArgumentError, "object must be a Ruby object" unless object.is_a?(Object)
    raise ArgumentError, "object does not have attribute #{attribute_name}" unless object.respond_to?(attribute_name)
    raise ArgumentError, "preceding_object's #{attribute_name} is greater than following_object's #{attribute_name}" if preceding_object && following_object && preceding_object.send(attribute_name) > following_object.send(attribute_name)
  end

  # Updates the attribute of the object and saves it.
  #
  # @param object [Object] The object to update and save.
  # @param attribute_name [Symbol] The name of the attribute to update.
  # @param options [Hash] Additional options for saving the object.
  #   - :validate [Boolean] Whether to validate the object before saving. Default is true.
  #
  # @raise [ActiveRecord::RecordInvalid] If the object is invalid.
  def self.update_attribute(object, attribute_name, options)
    object.update_attribute(attribute_name, value)
  end

  def self.save_object(object, options)
    validate = [false, "false"].include?(options[:validate]) ? false : true
    if options[:save] == "save!"
      object.save!(validate: validate)
    elsif options[:save] == "save"
      object.save(validate: validate)
    end
  end
end
