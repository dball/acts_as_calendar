require File.dirname(__FILE__) + '/../spec_helper'

describe CalendarEvent do
  describe "all events", :shared => true do
    it "should have a calendar" do
      @event.calendar.class.should == Calendar
    end

    it "should have occurrences" do
      @event.occurrences.all? {|e| e.class == CalendarDate}.should be_true
    end

    it "should have recurrences" do
      @event.recurrences.all? {|e| e.class == CalendarRecurrence}.should be_true
    end

    it "should have dates" do
      @event.dates.all? {|e| e.class == CalendarDate}.should be_true
    end
  end

  describe "when created empty" do
    before(:all) do
      @event = Factory(:calendar_event)
    end

    it_should_behave_like "all events"
  end

  describe "when it has an occurrence" do
    before(:all) do
      @event = Factory(:calendar_event)
      @event.calendar.fill_dates(Date.parse('2008-01-01') .. Date.parse('2008-12-31'))
      @cdate = CalendarDate.find_by_value('2008-07-04')
      @event.occurrences << @cdate
    end

    it_should_behave_like "all events"

    it "should have an occurrence" do
      @event.occurrences.should == [@cdate]
    end

    it "should have a date" do
      @event.dates.should == [@cdate]
    end
  end
end
