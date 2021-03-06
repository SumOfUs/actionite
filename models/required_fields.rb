module RequiredFields
  def required_field_options
    [:member_name, :email_address, :city, :country, :state, :zip]
  end

  def add_required_fields(fields)
    if fields.respond_to? :each
      fields.each do |field|
        self.add_required_field field
      end
    else
      self.add_required_field fields
    end
  end

  def required_fields_list
    if self.required_fields.nil?
      []
    else
      self.required_fields.split '|'
    end
  end

  def field_required?(symbol)
    if self.required_field_options.include? symbol
      self.required_fields_list.include? symbol.to_s
    else
      raise StandardError "#{symbol} is not an acceptable value."
    end
  end

  # To be used when new required fields are sent, prior to adding them again.
  def reset_required_fields
    self.required_fields = nil
  end

  protected
  def add_required_field(field)
    if self.required_field_options.include? field.to_sym
      if not self.required_fields_list.include? field.to_s
        if self.required_fields_list.empty?
          self.required_fields = "#{field}"
        else
          self.required_fields = "#{self.required_fields}|#{field}"
        end
      end
    else
      raise StandardError "#{field} is not an acceptable value."
    end
  end
end