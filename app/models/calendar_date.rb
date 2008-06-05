class CalendarDate < ActiveRecord::Base
  belongs_to :calendar
  has_and_belongs_to_many(:occurrences,
    {:class_name=>'CalendarEvent', :join_table=>'calendar_occurrences'})
  has_and_belongs_to_many(:dates,
    {:class_name=>'CalendarEvent', :join_table=>'calendar_event_dates'})
  
  def self.create_for_date(calendar, date)
    create({:weekday => date.wday,
      :monthweek => date.mday % 7,
      :monthday => date.mday,
      :value => date,
      :calendar => calendar})
  end
end
