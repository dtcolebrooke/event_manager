# frozen_string_literal: true

# gets first names of attendees
class EventManager
  require 'csv'

  attr_accessor :lines, :first_names

  def initialize
    @lines = CSV.open('F:/repos/event_manager/event_attendees.csv', headers: true)
    start
  end

  def start
    puts 'Event Manager Initialized!'
  end

  def list_first_names(file: @lines)
    file.each do |row|
      retrieve_the_name(row)
    end
  end

  def retrieve_the_name(row)
    @first_names = row[2]
    list_name(names: @first_names)
  end

  def list_name(names:)
    puts names
  end

  attendees = EventManager.new
  attendees.list_first_names
end
