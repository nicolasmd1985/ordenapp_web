class OutThing < ApplicationRecord

  has_many :histories
  has_many :positions
  has_many :orders
  has_many :maintenaces
  belongs_to :thing, optional:true
  belongs_to :customer, class_name: 'User', optional: true
  belongs_to :user, class_name: 'User', optional: true

end
