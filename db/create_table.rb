require "sequel"
require_relative 'define_tables'

POSTGRES_DB = ENV.fetch("POSTGRES_DB")
DB = Sequel.connect(POSTGRES_DB)

campaigners_table DB
petitions_table DB
donations_table DB
