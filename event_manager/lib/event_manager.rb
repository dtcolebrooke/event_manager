class EventManager
  require 'csv'

  attr_accessor :lines

   def initialize
    @lines = CSV.open('F:/repos/event_manager/event_attendees.csv', headers: true)
    start
   end
# Does this File actually exist? File check with method.
# puts File.exist? 'F:/repos/event_manager/event_attendees.csv'

def start
  puts 'Event Manager Initialized!'
end

def first_names(names: @lines)
  names.each do |row|
    name = row[2]
    puts name
  end
 end

 attendees = EventManager.new
 attendees.first_names
end