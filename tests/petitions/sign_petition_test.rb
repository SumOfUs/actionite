require "cuba/test"
require_relative "../helper"

prepare do
  # Deletes the `petitions` table (in case it's already created)
  DB[:petitions].delete if DB.table_exists?(:petitions)
end

setup do
  # Create `petitions` table
  petitions_table(DB)

  # Create a petition using the seed file.
  Petition.create(PETITIONS[0])
end

scope do
  test "sign petition without adding any input in the form" do |petition|
    post "/petition/sign/#{petition.slug}",
      { signature: { email: "", full_name: "", country: "", id_zip: "" } }

    assert last_response.body.include?("Email is required")
    assert last_response.body.include?("Full name is required")
    assert last_response.body.include?("Country is required")
    assert last_response.body.include?("Postal/ZIP code is required")
  end

  test "sign petition without email" do |petition|
    post "/petition/sign/#{petition.slug}",
      { signature: { email: "",
                     full_name: "John Doe",
                     country: "United States",
                     id_zip: "10010" } }

    assert last_response.body.include?("Email is required")
    assert !last_response.body.include?("Full name is required")
    assert !last_response.body.include?("Country is required")
    assert !last_response.body.include?("Postal/ZIP code is required")
  end

  test "sign petition without full_name" do |petition|
    post "/petition/sign/#{petition.slug}",
      { signature: { email: "johndoe@mail.com",
                     full_name: "",
                     country: "United States",
                     id_zip: "10010" } }

    assert !last_response.body.include?("Email is required")
    assert last_response.body.include?("Full name is required")
    assert !last_response.body.include?("Country is required")
    assert !last_response.body.include?("Postal/ZIP code is required")
  end

  test "sign petition without country" do |petition|
    post "/petition/sign/#{petition.slug}",
      { signature: { email: "johndoe@mail.com",
                     full_name: "John Doe",
                     country: "",
                     id_zip: "10010" } }

    assert !last_response.body.include?("Email is required")
    assert !last_response.body.include?("Full name is required")
    assert last_response.body.include?("Country is required")
    assert !last_response.body.include?("Postal/ZIP code is required")
  end

  test "sign petition without Postal/ZIP code" do |petition|
    post "/petition/sign/#{petition.slug}",
      { signature: { email: "johndoe@mail.com",
                     full_name: "John Doe",
                     country: "United States",
                     id_zip: "" } }

    assert !last_response.body.include?("Email is required")
    assert !last_response.body.include?("Full name is required")
    assert !last_response.body.include?("Country is required")
    assert last_response.body.include?("Postal/ZIP code is required")
  end

  test "sign petition successfully" do |petition|
    post "/petition/sign/#{petition.slug}",
      { signature: { email: "johndoe@mail.com",
                     full_name: "John Doe",
                     country: "United States",
                     id_zip: "10010" } }

    assert last_response.body.include?("Sharing is caring!")
  end
end
