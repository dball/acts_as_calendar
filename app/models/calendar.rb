class Calendar < ActiveRecord::Base
  extend ActsAsCalendar

  has_many(:dates, 
    {:class_name=>'CalendarDate', :order=>'value', :dependent=>:delete_all}) do
    def values
      map {|d| d.value}
    end
  end

  has_many(:events, {:class_name=>'CalendarEvent', :dependent=>:destroy}) do
    def create_for_dates(dates)
      event = create
      if (dates.is_a?(String))
        dates = self.parse_dates(d = dates)
      end
      raise ArgumentError, d if dates.nil?
      if (dates.is_a?(Hash))
        event.recurrences.create(dates)
      else
        dates.each do |date|
          event.occurrences << CalendarDate.find_by_value(date)
        end
      end
      event
    end

    def find_by_date(date)
      find(:all, {:include=>:dates, :conditions => ['value = ?', date]})
    end

    def find_by_dates(start_date, end_date)
      find(:all, {:include=>:dates, :conditions => ['value BETWEEN ? AND ?', start_date, end_date]})
    end
  end

  def self.create_for_dates(start_date = nil, end_date = nil)
    calendar = create()
    start_date ||= Date.today
    end_date ||= 5.years.since(start_date)
    calendar.fill_dates(start_date .. end_date)
    calendar
  end

  def fill_dates(values)
    values.each { |date| dates.create(:value => date) }
  end

  def to_ical
    ical = Icalendar::Calendar.new
    ical.prodid = 'ActsAsCalendar'
    ical.name = 'Foo'
    ical.to_ical
    events.each do |event|
      ical.event do
      end
    end
  end
end
