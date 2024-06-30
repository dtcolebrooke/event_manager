class EventManager
  require 'csv'

  attr_accessor :lines

  def initialize
    @lines = CSV.open('F:/repos/event_manager/event_attendees.csv', headers: true)
    start
  end

  def start
  puts 'Event Manager Initialized!'
  end

  def list_first_names(file: @lines)
    file.each do |row|
      print_the_name(row)
    end
   end

  def print_the_name(row)
      first_names = row[2]
      puts first_names
  end

   attendees = EventManager.new
   attendees.list_first_names
end