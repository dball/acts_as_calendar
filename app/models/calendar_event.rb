class CalendarEvent < ActiveRecord::Base
  belongs_to :calendar
  has_many(:recurrences, {:class_name=>'CalendarRecurrence'})
  has_and_belongs_to_many(:occurrences, 
    {:class_name=>'CalendarDate', :join_table=>'calendar_occurrences'})
  has_and_belongs_to_many(:dates, 
    {:class_name=>'CalendarDate', :join_table=>'calendar_event_dates'})
end
