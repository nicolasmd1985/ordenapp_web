class AddSubstatusToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :substatus, foreign_key: true, optional: true
  end
end
