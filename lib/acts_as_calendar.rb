# Some methods for parsing date expressions from strings
module ActsAsCalendar
  def included?(base)
    base.class_eval do
      def monthweek(value)
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
    
      # FIXME repeats data from monthweek. we should probably get a slightly more
      # robust parser going here
      def parse_dates(string)
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
      def shift_date(string)
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
    end
  end
end

#module Icalendar
#  DAYCODES = ['SU', 'MO', 'TU', 'WE', 'TH', 'FR', 'SA']
#
#  class Calendar < Component
#    ical_property :x_wr_calname, :name
#  end
#end
