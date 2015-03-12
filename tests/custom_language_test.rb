require_relative '../db/define_tables'
require 'sequel'

setup do
  # Need to set up our in-memory DB before we initialize the model.
  db = Sequel.sqlite # In-memory SQLite DB
  donations_table db

  # Now we can initialize the model.
  require_relative '../models/donation'
  Donation.new
end

test 'it should present a list of custom languages' do |donation|
  assert donation.language_options == {
             english: '/rest/v1/language/100/',
             french: '/rest/v1/language/103/',
             german: '/rest/v1/language/104/'
         }
end

test 'it should reverse a language to get the language name' do |donation|
  assert donation.reverse_language('/rest/v1/language/100/') == 'English'
  assert donation.reverse_language('/rest/v1/language/103/') == 'French'
end