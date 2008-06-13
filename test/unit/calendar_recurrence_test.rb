require File.dirname(__FILE__) + '/../test_helper'

class CalendarRecurrenceTest < Test::Unit::TestCase
  def setup
    Calendar.delete_all
    @event = CalendarEvent.generate
  end

  def test_consistency
    {
      [nil, nil, nil] => false,
      [1, nil, nil] => [:monthly?],
      [1, 0, nil] => false,
      [1, nil, 0] => false,
      [1, 0, 0] => false,
      [nil, 0, nil] => false,
      [nil, nil, 0] => [:weekly?],
      [nil, 0, 0] => [:monthly?, :weekly?],
    }.each do |params, value|
      recurrence = @event.recurrences.build(
        {:monthday => params[0], :monthweek => params[1], :weekday => params[2]})
      if !value
        assert !recurrence.valid?
      else
        assert recurrence.valid?
        value.each {|sym| assert recurrence.send(sym)}
      end
    end
  end
end
