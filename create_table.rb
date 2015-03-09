require "sequel"

POSTGRES_DB = ENV.fetch("POSTGRES_DB")
DB = Sequel.connect(POSTGRES_DB)

begin
  DB.table_exists? :campaigners
rescue
  # Create the table
  DB.create_table :campaigners do
    primary_key :id
    String :google_id
    String :email
  end
end

begin
  DB.table_exists? :petitions
rescue
  # Create the table
  DB.create_table :petitions do
    primary_key :id
    # Unique identifiers
    String :name, null: false
    String :slug, null: false
    unique :name
    unique :slug

    # Required values
    Text :body, null: false
    Text :mobile_body, null: false
    String :title, null: false
    String :facebook_title, null: false

    # The other details
    String :language, default: '/rest/v1/language/100/'
    Text :alt_body
    String :image_url
    String :image_text
    String :required_fields
    String :suggested_tweets
    Integer :goal
    TrueClass :auto_increment_goal, :default => false
  end
end
