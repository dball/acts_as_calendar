class CalendarRecurrence < ActiveRecord::Base
  belongs_to :calendar_event

  validates_presence_of :calendar_event

  validate :validate_pattern

  def validate_pattern
    errors.add_to_base('Invalid pattern') if !(monthly? || weekly?)
  end

  # Just a monthday or a monthweek and a weekday
  def monthly?
    (!monthday.nil? && monthweek.nil? && weekday.nil?) || 
      (monthday.nil? && !monthweek.nil? && !weekday.nil?)
  end

  # No monthday and a weekday
  def weekly?
    monthday.nil? && !weekday.nil?
  end
end
