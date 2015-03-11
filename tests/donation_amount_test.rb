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

test 'it should not have any default donation amounts' do |donation|
  assert donation.donation_amounts.nil?
end

test 'adding a single donation amount should end up with one' do |donation|
  donation.add_donation_amounts 5
  assert donation.donation_amounts == '5'
end

test 'adding multiple donation amounts should end up with more than one' do |donation|
  donation.add_donation_amounts [5, 10]
  assert donation.donation_amounts == '5|10'
end

test 'adding a duplicate amount does nothing' do |donation|
  donation.add_donation_amounts [5, 10]
  assert donation.donation_amounts == '5|10'
  donation.add_donation_amounts 10
  assert donation.donation_amounts == '5|10'
end

test 'restting donation amounts resets to nil' do |donation|
  donation.add_donation_amounts [5, 10]
  assert donation.donation_amounts == '5|10'
  donation.reset_donation_amounts
  assert donation.donation_amounts.nil?
end

test 'inputting invalid values throws an error' do |donation|
  assert_raise StandardError do
    donation.add_donation_amounts 'thing'
  end
  assert_raise StandardError do
    donation.add_donation_amounts 0
  end
  assert_raise StandardError do
    donation.add_donation_amounts -5
  end
end

test 'adding an amount should flag it as valid' do |donation|
  donation.add_donation_amounts [5, 10]
  assert donation.donation_amounts == '5|10'
  assert donation.donation_amount? 5
  assert donation.donation_amount? 10
  assert !donation.donation_amount?(20)
end