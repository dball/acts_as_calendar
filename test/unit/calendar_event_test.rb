require File.dirname(__FILE__) + '/../test_helper'
require 'set'

class CalendarEventTest < Test::Unit::TestCase
  def setup
    Calendar.delete_all
    @event = CalendarEvent.generate
  end

  def build(params)
    @event.recurrences.build(
      {:monthday => params[0], :monthweek => params[1], :weekday => params[2]})
  end

  def test_to_rrules
    expectations = {
      [1, nil, nil] => {'FREQ'=>'MONTHLY', 'BYMONTHDAY'=>'1'},
      [nil, nil, 0] => {'FREQ'=>'WEEKLY', 'BYDAY'=>'SU'},
      [nil, 0, 0] => {'FREQ'=>'MONTHLY', 'BYDAY'=>'1SU'},
    }
    expectations.each do |params, rrules|
      recurrence = build(params)
      assert_equal([rrules], @event.to_rrules)
      @event.recurrences.clear
    end

    build([nil, nil, 0])
    build([nil, nil, 1])
    build([nil, nil, 6])
    assert_equal([{'FREQ'=>'WEEKLY', 'BYDAY'=>'SU,MO,SA'}], @event.to_rrules)
  end
end
