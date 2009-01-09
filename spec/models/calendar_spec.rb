require File.dirname(__FILE__) + '/../spec_rails_plugin_helper'

describe Calendar, "when empty" do
  before(:each) do
    @calendar = Factory(:calendar)
  end

  it "should have no dates" do
    @calendar.dates.should == []
    @calendar.dates.values.should == []
  end

  it "should have no events" do
    @calendar.events.should == []
  end

  it "should fill with dates" do
    dates = (Date.parse('2008-01-01') .. Date.parse('2008-01-02'))
    @calendar.fill_dates(dates)
    @calendar.dates.values.should == dates.to_a
  end
end

describe Calendar, "when created for certain dates" do
  before(:each) do
    @dates = (Date.today .. 2.days.since(Date.today))
    @calendar = Calendar.create_for_dates(@dates.first, @dates.last)
  end

  it "should have those dates" do
    @calendar.dates.values.should == @dates.to_a
  end

  it "should find no events" do
    @calendar.events.find_by_date(@dates.first).should == []
  end
end
