require 'sequel'

class Petition < Sequel::Model(:petitions)
  plugin :validation_helpers

  def validate
    super
    validates_presence [:name, :slug, :title, :body, :mobile_body, :facebook_title]
    validates_unique :name
    validates_unique :slug
  end

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

  def self.find_by_slug(slug)
    self.where(slug: slug).first
  end

  protected
  def add_required_field(field)
    if self.required_field_options.include? field
      if not self.required_fields_list.include? field
        if self.required_fields_list.empty?
          self.required_fields = "#{field}"
        else
          self.required_fields = "#{self.required_fields}|#{field}"
        end
      end
    else
      raise ArgumentError("#{field} is not an acceptable value.")
    end
  end
end