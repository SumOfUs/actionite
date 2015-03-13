Encoding.default_external = "UTF-8"

require 'actionkit_connector'
require "cuba"
require "cuba/contrib"
require "mote"
require "rack/protection"
require "scrivener"
require "sequel"
require "shield"

# Grab environment variables from .env file
APP_SECRET = ENV.fetch("APP_SECRET")
CLIENT_ID = ENV.fetch("CLIENT_ID")
POSTGRES_DB = ENV.fetch("POSTGRES_DB")
GOOGLE_FETCH_USER = ENV.fetch("GOOGLE_FETCH_USER")

# Need our ActionKit connection data.
AK_API_USER = ENV.fetch 'AK_API_USERNAME'
AK_API_PASSWORD = ENV.fetch 'AK_API_PASSWORD'
AK_API_HOST = ENV.fetch 'AK_API_URL'

# Connect to the db
DB = Sequel.connect(POSTGRES_DB)

# Connect to ActionKit
AK_CONNECTOR = ActionKitConnector::Connector.new AK_API_USER, AK_API_PASSWORD, AK_API_HOST

# Load plugins
Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::TextHelpers
Cuba.plugin Shield::Helpers

# Load all files of these folders
Dir["./filters/**/*.rb"].each  { |rb| require rb }
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

  # Sign petition
  on "petition/sign/:slug" do |slug|
    petition = Petition.find_by_slug slug

    if petition
      on post, param("signature") do |atts|

        signature = NewSignature.new(atts)

        on signature.valid? do
          # Creates action in ActionKit
          AK_CONNECTOR.create_action(
                        name = petition.slug,
                        email = signature.email
                        # full_name = signature.full_name,
                        # country = signature.country,
                        # id_zip = signature.id_zip,
                        # canonical_url = "#{env['HTTP_ORIGIN']}/petition/#{slug}"
                    )
          # Redirects to Share page
          render("petition/share", title: "SumOfUs", slug: slug)
        end

        on default do
          render("guests/petition", title: "SumOfUs", petition: petition,
                  signature: signature)
        end
      end
    else
      not_found!
    end
  end

  # Petition page
  on "petition/:slug" do |slug|
    petition = Petition.find_by_slug slug

    if petition
      signature = NewSignature.new({})
      render("guests/petition", title: "SumOfUs", petition: petition,
        signature: signature)
    else
      not_found!
    end
  end

  # Donation page
  on "donation/:slug" do |slug|
    donation = Donation.find_by_slug slug
    if donation
      render("guests/donation", title: "SumOfUs", donation: donation)
    else
      not_found!
    end
  end

  # Donate page (for a general donation not related to any specific campaign)
  on "donate" do
    render("guests/donate", title: "SumOfUs")
  end

  # Homepage for members (guests) when going to http://192.168.59.103:5000
  on root do
    petitions = Petition.order(Sequel.desc(:created_at)).limit(5)
    donations = Donation.order(Sequel.desc(:created_at)).limit(5)
    render("home", title: "SumOfUs", petitions: petitions, donations: donations)
  end

  on authenticated(Campaigner) do
    run Campaigners
  end

  on default do
    run Guests
  end
end
