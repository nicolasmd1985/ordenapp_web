class History < ApplicationRecord
  # belongs_to :thing, optional: true
  belongs_to :out_thing, optional: true
  belongs_to :order, optional: true
  belongs_to :supervisor, class_name: 'User', optional: true
	belongs_to :tecnic, class_name: 'User', optional: true
	belongs_to :customer, class_name: 'User', optional:true
  belongs_to :out_thing, optional: true
  belongs_to :substatus, optional:true



  serialize :photos,Array

  def tecnic_name
    name = "#{self.try(:user).try(:first_name)} #{self.try(:user).try(:last_name)}"
  end

end
