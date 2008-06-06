class CalendarEvent < ActiveRecord::Base
  belongs_to :calendar

  # discrete event occurrences
  has_and_belongs_to_many(:occurrences, 
    {:class_name=>'CalendarDate', :join_table=>'calendar_occurrences'})

  # recurring date patterns
  has_many(:recurrences, {:class_name=>'CalendarRecurrence'})

  # actual dates, including occurrences and recurrences
  # FIXME - see readonly complaint in calendar_date
  has_and_belongs_to_many(:dates, 
    {:class_name=>'CalendarDate', :join_table=>'calendar_event_dates'})

  validates_presence_of :calendar
end
