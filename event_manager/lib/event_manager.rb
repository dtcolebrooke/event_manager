# frozen_string_literal: true

# gets first names of attendees
class EventManager
  require 'csv'

  attr_accessor :lines, :names, :zipcodes

  def initialize
    @lines = CSV.open(
      'F:/repos/event_manager/event_attendees.csv',
       headers: true,
       header_converters: :symbol
       )
    start
    iterate_through_csv
  end

  def start
    puts 'Event Manager Initialized!'
  end

  def iterate_through_csv(file: @lines)
    file.each do |row|
      store_rows(row)
    end
  end

  def store_rows(row)
    @names = row[:first_name]
    @zipcodes = row[:zipcode]
    names_and_zipcodes
  end

  def names_and_zipcodes list_names: names, list_zipcodes: zipcodes
    puts "#{list_names} #{list_zipcodes}"
  end

  attendees = EventManager.new
  attendees.names_and_zipcodes
end
