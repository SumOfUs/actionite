module CustomLanguage
  def language_options
    {
        english: '/rest/v1/language/100/',
        french: '/rest/v1/language/103/',
        german: '/rest/v1/language/104/'
    }
  end

  def reverse_language(language)
    self.language_options.key(language).to_s.capitalize
  end
end
