require File.dirname(__FILE__) + '/../test_helper'

class CalendarTest < Test::Unit::TestCase
  def setup
    Calendar.delete_all
    @start_date = Date.today
    @end_date = 1.months.since(@start_date)
    @calendar = Calendar.create_for_dates(@start_date, @end_date)
    @calendar.events.create_for_dates([@start_date, 1.days.since(@start_date)])
  end

  def test_calendar_dates
    assert_equal(
      (@start_date .. @end_date).to_a,
      @calendar.dates.values)
  end

  def test_calendar_events
    events = CalendarEvent.find(:all)
    assert_equal(events, @calendar.events)
    assert_equal([events.first], @calendar.events.find_by_date(@start_date))
    assert_equal([], @calendar.events.find_by_date(@end_date))
    assert_equal(events, @calendar.events.find_by_dates(@start_date, @end_date))
  end
end
