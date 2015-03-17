require "cuba/test"
require_relative "../helper"

scope do
  test "go to homepage successfully" do
    get "/"

    assert last_response.body.include?("Welcome to SumOfUs!")
  end

  test "go to homepage successfully" do
    get "/donate"

    assert last_response.body.include?("Make a donation to support Our ongoing work")
  end

  test "go to page that doesn't exist" do
    get "/wrong_url"

    assert last_response.body.include?("That makes me a sad panda")
  end
end
