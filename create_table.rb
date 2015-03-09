require "sequel"

POSTGRES_DB = ENV.fetch("POSTGRES_DB")
DB = Sequel.connect(POSTGRES_DB)

DB.create_table :campaigners do
  primary_key :id
  String :google_id
  String :email
  String :image
end
