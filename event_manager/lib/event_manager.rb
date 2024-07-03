# frozen_string_literal: true

# gets first names of attendees
class EventManager
  require 'csv'
  require 'google/apis/civicinfo_v2'
  require 'erb'

  attr_accessor :lines, :name, :zipcodes, :legislators, :civic_info, :template_letter, :personal_letter, :erb_template,
                :form_letter, :id, :filename

  def initialize
    @civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = File.read('F:/secret.txt').strip
    @template_letter = File.read('F:/repos/form_letter.erb')
    @erb_template = ERB.new template_letter
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

  def trigger_form_letters
    iterate_through_csv
  end

  def iterate_through_csv(file: lines)
    file.each do |row|
      store_rows(row)
    end
  end

  def store_rows(row)
    self.id = row[0]
    self.name = row[:first_name]
    self.zipcodes = row[:zipcode]
    handle_zipcodes
    self.legislators = legislators_by_zipcode
    self.form_letter = erb_template.result(binding)
    create_output_folder
    specialized_thank_you
    create_the_letters
  end

  def legislators_by_zipcode(zipcode: zipcodes)
    self.legislators = civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
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

  def create_output_folder
    Dir.mkdir('output') unless Dir.exist?('output')
  end

  def specialized_thank_you(ids: id)
    self.filename = "output/thanks_#{ids}.html"
  end

  def create_the_letters
    File.open(filename, 'w') do |file|
      prints_form_letter(file)
    end
  end

  def prints_form_letter(file)
    file.puts form_letter
  end

  def output_to_forms(list_names: name, list_zipcodes: zipcodes, info_legislators: legislators)
    puts "#{list_names} #{list_zipcodes} #{info_legislators}"
  end

  attendees = EventManager.new
  attendees.trigger_form_letters
end
