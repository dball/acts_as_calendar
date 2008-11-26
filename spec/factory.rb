require 'factory_girl'

Factory.define :calendar do |calendar|
end

Factory.define :calendar_event do |event|
  event.association :calendar, :factory => :calendar
  event.start_date '2008-01-01'
  event.end_date '2008-01-01'
end

Factory.define :calendar_date do |date|
  date.value '2008-01-01'
  date.association :calendar, :factory => :calendar
  date.holiday 0
end
