class Subsidiary < ApplicationRecord
  has_many :users
  has_many :orders
  has_many :things
  has_many :categories
  has_many :components
  has_many :order_rates
  has_many :tools
  belongs_to :status
  belongs_to :corporation
end