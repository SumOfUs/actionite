class Campaigner < Sequel::Model(:campaigners)
  include Shield::Model

  def self.fetch(google_id)
    self.where(google_id: google_id).first
  end
end
