require "cuba/test"
require_relative "../helper"

# Monkeypatch Google SignIn
module Google
  def self.fetch_user(access_token)
    return {"kind"=>"plus#person",
            "etag"=>"\"RqKWnRU4WW46-6W3rWhLR9iFZQM/kcT6GjinXWesHqvTtumowMTYI8k\"",
            "gender"=>"female",
            "emails"=>[{
              "value"=>"johndoe@sumofus.org",
              "type"=>"account"}],
            "objectType"=>"person",
            "id"=>"123456789012345678901",
            "displayName"=>"John Doe",
            "name"=>{"familyName"=>"Doe", "givenName"=>"John"},
            "url"=>"https://plus.google.com/123456789012345678901",
            "image"=>{"url"=>"https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg?sz=50", "isDefault"=>true},
            "isPlusUser"=>true,
            "circledByCount"=>0,
            "verified"=>false,
            "domain"=>"sumofus.org"}
  end
end

setup do
  DB[:campaigners].delete if DB.table_exists?(:campaigners)

  Campaigner.create(google_id: "123456789012345678901",
                    email: "johndoe@sumofus.org",
                    image: "https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg?sz=50",
                    given_name: "John",
                    family_name: "Doe")
end

scope do
  test "login successfully and redirect to dashboard" do
    get "/login/1234567890"

    follow_redirect!

    assert last_response.body.include?("Welcome, John!")
  end

  test "go to dashboard without being logged in" do
    get "/dashboard"

    assert last_response.body.include?("It seems you're not logged in to Actionite")
  end

  test "go to a page that doesn't exist" do
    get "/login/1234567890"

    follow_redirect!

    get "/wrong_url"

    assert last_response.body.include?("That makes me a sad panda")
  end

  test "go to create donation page" do
    get "/login/1234567890"

    follow_redirect!

    get "/donations/new"

    assert last_response.body.include?("Create New Donation Page")
  end

  test "go to create petition page" do
    get "/login/1234567890"

    follow_redirect!

    get "/petitions/new"

    assert last_response.body.include?("Create New Petition")
  end

  test "log out and redirect to guests homepage" do
    get "/login/1234567890"

    follow_redirect!

    get "/logout"

    follow_redirect!

    assert last_response.body.include?("Welcome to SumOfUs!")
  end
end
