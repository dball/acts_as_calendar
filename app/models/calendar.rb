class Calendar < ActiveRecord::Base
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
        dates = Calendar.parse_dates(d = dates)
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

  def self.monthweek(value)
    case value.downcase
      when 'last': -1
      when '1st': 0
      when 'first': 0
      when '2nd': 1
      when 'second': 1
      when '3rd': 2
      when 'third': 2
      when '4th': 3
      when 'fourth': 3
      else raise ArgumentError, value
    end
  end

  def self.parse_dates(string)
    if md = /^\s*(?:Every )?\s*(1st|2nd|3rd|4th|last|first|second|third|fourth)?(?:\s*(?:and|&)\s*(1st|2nd|3rd|4th|last|first|second|third|fourth))?\s*((?:Sun|Mon|Tues|Wednes|Thurs|Fri|Satur)day)s?\s*(?:of each month|of the month|every month)?\s*$/i.match(string)
      if md[2]
        monthweek = [monthweek(md[1]), monthweek(md[2])]
      elsif md[1]
        monthweek = monthweek(md[1])
      else
        monthweek = nil
      end
      weekday = Date::DAYNAMES.index(md[3])
      return {:weekday => weekday, :monthweek => monthweek }
    end
    date, string = shift_date(string)
    return nil if date.nil?
    dates = [date]
    return dates if string.length == 0
    if md = /^(-|through|thru|to)\s*/.match(string)
      string = string.slice(md[0].length, string.length)
      date, string = shift_date(string)
      return nil if date.nil? || string.length != 0
      return (dates[0]..date)
    else
      while md = /^\s*(,|&|and)\s*/.match(string)
        string = string.slice(md[0].length, string.length)
        date, string = shift_date(string)
        dates << date
      end
      return dates if string.length == 0
    end
    return nil
  end

  # Tries to parse and remove a date in the form mm/dd/yy from the front of the 
  # string. On success, it returns [date, tail] otherwise [nil, string].
  def self.shift_date(string)
    md = /^\s*(\d{1,2})\/(\d{1,2})(\/\d{2,4})?\s*/.match(string)
    return [nil, string] unless md
    day = md[2].to_i
    month = md[1].to_i
    year = md[3].nil? ? Date.today.year : md[3].slice(1..md[3].length).to_i
    year += 2000 if year < 100
    begin
      [Date.new(year, month, day), string.slice(md[0].length, string.length)]
    rescue ArgumentError
      [nil, string]
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
    values.each do |date|
      dates << CalendarDate.create_for_date(self, date)
    end
  end
end
