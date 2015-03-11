module SlugLocated
  def self.find_by_slug(slug)
    self.where(slug: slug).first
  end
end