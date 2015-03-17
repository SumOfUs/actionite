class NewSignature < Scrivener
  attr_accessor :email, :full_name, :country, :id_zip

  def validate
    assert_email   :email
    assert_present :full_name
    countries = COUNTRIES - ["----"]
    assert_member :country, countries
    assert_present :id_zip
  end
end
