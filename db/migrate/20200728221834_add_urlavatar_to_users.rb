class AddUrlavatarToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :urlavatar, :string
  end
end
