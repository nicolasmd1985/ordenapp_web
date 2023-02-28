class AddCustomerToThings < ActiveRecord::Migration[5.2]
  def change
    # customer relationship
    add_reference :things, :user, foreign_key: true
  end
end
