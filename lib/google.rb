require "net/http"
require "json"

module Google
  def self.fetch_user(access_token)
    uri = URI(GOOGLE_FETCH_USER + '?access_token=' + access_token)
    response = Net::HTTP.get(uri)

    return JSON.parse(response)
  end
end
