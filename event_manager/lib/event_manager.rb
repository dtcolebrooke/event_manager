# frozen_string_literal: true

# gets first names of attendees
class EventManager
  require 'csv'
  require 'google/apis/civicinfo_v2'

  attr_accessor :lines, :names, :zipcodes, :legislators, :civic_info

  def initialize
    @civic_info = civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = File.read('F:/secret.txt').strip
    @lines = CSV.open(
      'F:/repos/event_manager/event_attendees.csv',
      headers: true,
      header_converters: :symbol
    )
    start
  end

  def start
    puts 'Event Manager Initialized!'
  end

  def trigger_names_and_zipcodes
    iterate_through_csv
  end

  def iterate_through_csv(file: @lines)
    file.each do |row|
      store_rows(row)
    end
  end

  def store_rows(row)
    self.names = row[:first_name]
    self.zipcodes = row[:zipcode]
    handle_zipcodes
    list_officials
    results
  end

  def list_officials
    self.legislators = civic_info.representative_info_by_address(
      address: zipcodes,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )
    self.legislators = legislators.officials
  rescue Google::Apis::ClientError
    'You can find your representatives by visitiong www.commoncause.org/take-action/find-elected-officials'
  end

  def handle_zipcodes(zipcode: zipcodes)
    if zipcode.nil?
      self.zipcodes = '00000'
    elsif zipcode.length < 5
      self.zipcodes = zipcode.rjust(5, '0')
    elsif zipcode.length > 5
      self.zipcodes = zipcode[0..4]
    end
  end

  def results(list_names: names, list_zipcodes: zipcodes, info_legislators: legislators)
    puts "#{list_names} #{list_zipcodes} #{info_legislators}"
  end

  attendees = EventManager.new
  attendees.trigger_names_and_zipcodes
end
