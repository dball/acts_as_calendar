require File.dirname(__FILE__) + '/../factory'
require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../../../../config/environment'

describe Calendar do
  it "should have a date range" do
    calendar = Factory(:calendar)
    calendar.should_not be_nil
  end
end
