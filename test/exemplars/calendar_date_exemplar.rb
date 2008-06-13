class CalendarDate < ActiveRecord::Base
  generator_for(:value, :start => Date.today) { |prev| prev.succ }
end
