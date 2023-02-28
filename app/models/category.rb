class Category < ApplicationRecord
  has_many :orders
  has_many :things
  belongs_to :subsidiary

  validates_presence_of :name
  validates :name, length: {minimum: 3}
end
