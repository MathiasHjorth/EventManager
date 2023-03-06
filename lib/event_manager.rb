#frozen_string_literal: true
require 'csv'


puts 'Event Manager Initialized!'

def clean_zip_code(zip_code)
  zip_code = zip_code.rjust(5, '0')[0..4]
end

csv_content = CSV.open(
  "C:\\Users\\Mathias\\RubymineProjects\\EventManager\\lib\\event_attendees.csv",
  headers:true,
  header_converters: :symbol
)

csv_content.each do |row|

  name = row[:first_name]
  zip_code = clean_zip_code(row[:zipcode].to_s)

  puts"#{name} #{zip_code}"

end




