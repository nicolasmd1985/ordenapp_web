class Position < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :thing, optional: true
  belongs_to :out_thing, optional: true

  def self.position user
    @position = Position.includes(:user).where(user_id: user).last
  end
end
