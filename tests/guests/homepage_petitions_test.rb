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
  test "go to petition page successfully" do |petition|
    get "/petition/#{petition.slug}"

    assert last_response.body.include?("British Columbia, a Canadian province")
  end

  test "go to petition page that doesn't exist" do
    get "/petition/my_wrong_slug"

    assert last_response.body.include?("That makes me a sad panda")
  end
end
