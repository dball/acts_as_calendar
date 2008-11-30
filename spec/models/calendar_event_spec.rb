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

  describe "when in a 3 month calendar" do
    before(:all) do
      @calendar = Calendar.create_for_dates(Date.parse('2008-01-01'), Date.parse('2008-03-31'))
    end

    describe "when it has specific occurrences" do
      before(:all) do
        @event = Factory(:calendar_event, :calendar => @calendar)
        @cdates = ['2008-01-18', '2008-01-20', '2008-01-25'].map do |value|
          CalendarDate.find(:first, :conditions => { :value => value, :calendar_id => @calendar })
        end
        @cdates.each do |cdate|
          @event.occurrences << cdate
        end
      end
  
      it_should_behave_like "all events"
  
      it "should have the expected dates" do
        @event.dates.should == @cdates
      end
    end
  
    describe "when it has weekly recurrences" do
      before(:all) do
        @event = Factory(:calendar_event, :calendar => @calendar)
        @event.recurrences.create({ :weekday => 3 })
      end
  
      it_should_behave_like "all events"
  
      it "should have the expected dates" do
        @event.dates.should == ['2008-01-02', '2008-01-09', '2008-01-16', '2008-01-23', '2008-01-30', '2008-02-06', '2008-02-13', '2008-02-20', '2008-02-27', '2008-03-05', '2008-03-12', '2008-03-19', '2008-03-26'].map do |value|
          CalendarDate.find(:first, :conditions => { :value => value, :calendar_id => @event.calendar })
        end
      end
    end
  
    describe "when it has monthly day of month recurrences" do
      before(:all) do
        @event = Factory(:calendar_event, :calendar => @calendar)
        @event.recurrences.create({ :monthday => 15 })
      end
  
      it_should_behave_like "all events"
  
      it "should have the expected dates" do
        @event.dates.should == ['2008-01-15', '2008-02-15', '2008-03-15'].map do |value|
          CalendarDate.find(:first, :conditions => { :value => value, :calendar_id => @event.calendar })
        end
      end
    end

    describe "when it has monthly day of week recurrences" do
      before(:all) do
        @event = Factory(:calendar_event, :calendar => @calendar)
        @event.recurrences.create({ :weekday => 6, :monthweek => 0 })
      end
  
      it_should_behave_like "all events"
  
      it "should have the expected dates" do
        @event.dates.should == ['2008-01-05', '2008-02-02', '2008-03-01'].map do |value|
          CalendarDate.find(:first, :conditions => { :value => value, :calendar_id => @event.calendar })
        end
      end
    end

  end
end
