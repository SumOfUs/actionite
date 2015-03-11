require_relative '../db/define_tables'
require 'sequel'

setup do
  # Need to set up our in-memory DB before we initialize the model.
  db = Sequel.sqlite # In-memory SQLite DB
  petitions_table db

  # Now we can initialize the model.
  require_relative '../models/petition'
  Petition.new
end

test 'should not have any required fields by default' do |petition|
  assert petition.required_fields.nil?
end

test 'adding a single required field should end up with one' do |petition|
  petition.add_required_fields :member_name
  assert petition.required_fields == 'member_name'
end

test 'adding a list of required fields should end up with multiple' do |petition|
  petition.add_required_fields [:member_name, :email_address]
  assert petition.required_fields == 'member_name|email_address'
end

test 'adding a duplicate required field does nothing' do |petition|
  petition.add_required_fields [:member_name, :email_address]
  assert petition.required_fields == 'member_name|email_address'
  petition.add_required_fields :email_address
  assert petition.required_fields == 'member_name|email_address'
end

test 'adding an invalid required field throws an error' do |petition|
  assert_raise(StandardError) do
    petition.add_required_fields :not_a_valid_field
  end
end

test 'adding a valid field after other fields ends up with correct number' do |petition|
  petition.add_required_fields [:member_name, :email_address]
  assert petition.required_fields == 'member_name|email_address'
  petition.add_required_fields :city
  assert petition.required_fields == 'member_name|email_address|city'
end

test 'resetting required fields resets the list' do |petition|
  petition.add_required_fields [:member_name, :email_address]
  assert petition.required_fields == 'member_name|email_address'
  petition.reset_required_fields
  assert petition.required_fields.nil?
  petition.add_required_fields [:member_name, :email_address]
  assert petition.required_fields == 'member_name|email_address'
end

test 'adding a required field should flag it as required' do |petition|
  petition.add_required_fields [:member_name, :email_address]
  assert petition.required_fields == 'member_name|email_address'
  assert petition.field_required? :member_name
  assert petition.field_required? :email_address
  assert !petition.field_required?(:city)
end

