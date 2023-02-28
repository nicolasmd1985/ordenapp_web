class Maintenance < ApplicationRecord
  belongs_to :out_thing
  enum frequency: {day: 0, week: 1, month: 2, quarterly: 3, biannual: 4, year: 5}

end
