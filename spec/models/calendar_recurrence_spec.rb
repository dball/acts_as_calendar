require File.dirname(__FILE__) + '/../spec_helper'

describe CalendarRecurrence do
  it "should allow weekly events" do
    recurrence = Factory(:calendar_recurrence, { :weekday => 0 })
    recurrence.weekly?.should be_true
    recurrence.valid?.should be_true
  end

  it "should not allow weekly events with weekday < 0" do
    lambda { Factory(:calendar_recurrence, { :weekday => -1 }) }.should raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not allow weekly events with weekday > 6" do
    lambda { Factory(:calendar_recurrence, { :weekday => 7 }) }.should raise_error(ActiveRecord::RecordInvalid)
  end
end
