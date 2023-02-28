class AddTokenMessageToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :token_message, :string
  end
end
