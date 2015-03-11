require_relative '../models/required_fields'
require_relative '../models/custom_language'

class Petition < Sequel::Model(:petitions)
  include RequiredFields
  include CustomLanguage

  def self.find_by_slug(slug)
    self.where(slug: slug).first
  end
end
