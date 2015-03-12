class NewSignature < Scrivener
  attr_accessor :email, :full_name, :country, :id_zip

  def validate
    assert_present :email
    assert_present :full_name
    assert_present :country
    assert_present :id_zip
  end
end
