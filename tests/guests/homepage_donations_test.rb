require "cuba/test"
require_relative "../helper"

prepare do
  # Deletes the `donations` table (in case it's already created)
  DB[:donations].delete if DB.table_exists?(:donations)
end

setup do
  # Create `donations` table
  donations_table(DB)

  # Create a donation using the seed file.
  Donation.create(DONATIONS[0])
end

scope do
  test "go to donation page successfully" do |donation|
    get "/donation/#{donation.slug}"

    assert last_response.body.include?("orangutans and Sumatran tigers")
  end

  test "go to donation page that doesn't exist" do
    get "/donation/my_wrong_slug"

    assert last_response.body.include?("That makes me a sad panda")
  end
end
