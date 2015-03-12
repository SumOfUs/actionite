Encoding.default_external = "UTF-8"

require "cuba"
require "cuba/contrib"
require "mote"
require "rack/protection"
require "sequel"
require "shield"

# Grab environment variables from .env file
APP_SECRET = ENV.fetch("APP_SECRET")
CLIENT_ID = ENV.fetch("CLIENT_ID")
POSTGRES_DB = ENV.fetch("POSTGRES_DB")
GOOGLE_FETCH_USER = ENV.fetch("GOOGLE_FETCH_USER")

# Connect to the db
DB = Sequel.connect(POSTGRES_DB)

# Load plugins
Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::TextHelpers
Cuba.plugin Shield::Helpers

# Load all files of these folders
Dir["./helpers/**/*.rb"].each  { |rb| require rb }
Dir["./lib/**/*.rb"].each  { |rb| require rb }
Dir["./models/**/*.rb"].each  { |rb| require rb }
Dir["./routes/**/*.rb"].each  { |rb| require rb }

# Load helpers from 'helpers' folder
Cuba.plugin UserHelpers

# Add cookie with app secret to a session
Cuba.use Rack::Session::Cookie,
  key: "sumofus",
  secret: APP_SECRET

Cuba.use Rack::Protection, except: :http_origin
Cuba.use Rack::Protection::RemoteReferrer

# Make the public folder available to the app
Cuba.use Rack::Static,
  urls: %w[/js /css /img],
  root: File.expand_path("./public", __dir__)

Cuba.define do
  persist_session!

  # We set the 'guests' layout as master template (file: /views/layout.guests.mote)
  settings[:mote][:layout] = "layout.guests"

  # Petition page
  on "petition/:slug" do |slug|
    petition = Petition.find_by_slug slug
    render("guests/petition", title: "SumOfUs", petition: petition)
  end

  # Donation page
  on "donation/:slug" do |slug|
    donation = Donation.find_by_slug slug
    render("guests/donation", title: "SumOfUs", donation: donation)
  end

  # Donate page (for a general donation not related to any specific campaign)
  on "donate" do
    render("guests/donate", title: "SumOfUs")
  end

  # Homepage for members (guests) when going to http://192.168.59.103:5000
  on root do
    render("home", title: "SumOfUs")
  end

  on authenticated(Campaigner) do
    run Campaigners
  end

  on default do
    run Guests
  end
end
