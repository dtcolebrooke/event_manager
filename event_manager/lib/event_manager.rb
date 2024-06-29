class EventManager
  require 'csv'

  attr_accessor :lines

   def initialize
    @lines = File.readlines 'F:/repos/event_manager/event_attendees.csv'
    start
   end
# Does this File actually exist? File check with method.
# puts File.exist? 'F:/repos/event_manager/event_attendees.csv'

def start
  puts 'Event Manager Initialized!'
end

def first_names(names: @lines)
  names.each_with_index do |line, index|
    next if index == 0  
    columns = line.split(',')
    name = columns[2]
    puts name
  end
 end

 attendees = EventManager.new
 attendees.first_names
end