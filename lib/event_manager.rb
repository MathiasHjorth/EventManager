#frozen_string_literal: true
require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'date'
require 'time'

class Event_manager
  puts 'Event Manager Initialized!'

  def clean_zip_code(zip_code)
    zip_code = zip_code.rjust(5, '0')[0..4]
  end

  def find_peak_hour_of_registration(registration_dates)

    #get the hours value
    registration_dates.map! {|elem| DateTime.strptime(elem,'%m/%d/%y %H:%M').hour}


    hour_hash = {}
    #count up the frequency of each hour of the day of registration in hash
    registration_dates.each do |elem|
      if hour_hash.include?(elem) then
        hour_hash[elem] += 1
      else
        hour_hash[elem] = 1
      end
    end

    #return the most frequent hour of registration
    return hour_hash.key(hour_hash.values.map(&:to_i).max)

  end


  def clean_phone_number(phone_number)

    if phone_number.nil? then raise ArgumentError "phone_number was nil" end

    #remove any characters that are not digits
    phone_number = phone_number.scan(/\d+/).join

    digit_count = phone_number.to_s.length

    if(digit_count == 10) then
      return phone_number
    end

    if(digit_count == 11 && phone_number[0] == "1") then
      return phone_number[1..phone_number.to_s.length-1]
    end

    #return invalid phonenumber
    return "No phonenumber available"

  end


  def legislators_by_zip_code(zip_code)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
    begin
      civic_info.representative_info_by_address(
        address: zip_code,
        levels: 'country',
        roles: ['legislatorUpperBody', 'legislatorLowerBody']
      ).officials
    rescue
      'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
  end



  def save_thank_you_letter(id,form_letter)
    Dir.mkdir('output') unless Dir.exist?('output')

    filename = "output/thanks_#{id}.html"

    File.open(filename, 'w') do |file|
      file.puts form_letter
    end

  end

end




csv_content = CSV.open(
  "C:\\Users\\Mathias\\RubymineProjects\\EventManager\\lib\\event_attendees.csv",
  headers:true,
  header_converters: :symbol
)
obj1 = Event_manager.new()
template_letter = File.read("C:\\Users\\Mathias\\RubymineProjects\\EventManager\\form_letter.erb")
erb_template = ERB.new template_letter
registration_dates = []

csv_content.each do |row|

  id = row[0]
  name = row[:first_name]
  phone_number = obj1.clean_phone_number(row[:homephone])
  registration_dates.push(row[:regdate])
  zip_code = obj1.clean_zip_code(row[:zipcode].to_s)
  legislators = obj1.legislators_by_zip_code(zip_code)

  form_letter = erb_template.result(binding)

  obj1.save_thank_you_letter(id,form_letter)
end

puts obj1.find_peak_hour_of_registration(registration_dates)




