require_relative '../models/required_fields'
require_relative '../models/custom_language'
require_relative '../models/slug_located'
require_relative '../models/donation_amounts'

class Donation < Sequel::Model(:donations)
  include RequiredFields
  include CustomLanguage
  include DonationAmounts

  def self.find_by_slug(slug)
    self.where(slug: slug).first
  end
end
