require File.dirname(__FILE__) + '/spec_helper'
require 'acts_as_calendar'

describe ActsAsCalendar do
  before(:all) do
    class Test
      extend ActsAsCalendar
    end
  end

  describe "monthweek method" do
    it "on first" do
      Test.monthweek('first').should == 0
    end
    it "on last" do
      Test.monthweek('last').should == -1
    end
  end

  describe "parse weekly_dates method" do
    it "on Saturdays" do
      Test.parse_weekly_dates('Saturdays').should == 
        { :weekday => 6, :monthweek => nil }
    end

    it "on Every Friday" do
      Test.parse_weekly_dates('Every Friday').should ==
        { :weekday => 5, :monthweek => nil }
    end

    it "on every 3rd tuesday" do
      Test.parse_weekly_dates('every 3rd tuesday').should ==
        { :weekday => 2, :monthweek => 2 }
    end

    it "on 2nd and 4th Fridays of the month" do
      Test.parse_weekly_dates('2nd and 4th Fridays of the month').should ==
        { :weekday => 5, :monthweek => [1, 3] }
    end

    it "on foo" do
      Test.parse_weekly_dates('foo').should be_nil
    end
  end
end
