class Orders::Log < ApplicationRecord
  serialize :data_log, Array

  belongs_to :order
  belongs_to :user

end
