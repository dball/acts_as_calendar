class CalendarRecurrence < ActiveRecord::Base
  belongs_to :calendar_event

  validates_presence_of :calendar_event

  # Not sure it's a great idea to increment these in lockstep
  # Is the idea to generate all interesting permutations? That'd be cool.
  # I wonder if the object could tell its daddy how many instances of itself
  # it would take to check out the corner cases.
  generator_for(:weekday, :start=>0) { |prev| (prev + 1) % 7 }
  generator_for(:monthweek, :start=>0) { |prev| (prev + 1) % 4 }
  generator_for(:monthday, :start=>1) { |prev| (prev + 1) % 28 }
end
