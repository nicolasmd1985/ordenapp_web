class ChangeIndexEmailUsers < ActiveRecord::Migration[5.2]
  def change
    remove_index :users, :email
    add_index :users, :email, unique: false
  end
end
