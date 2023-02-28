class Positions::PositionLog < ApplicationRecord
  belongs_to :user
  belongs_to :position, optional: true
end
