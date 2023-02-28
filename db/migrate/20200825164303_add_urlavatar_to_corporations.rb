class AddUrlavatarToCorporations < ActiveRecord::Migration[5.2]
  def change
    add_column :corporations, :urlavatar, :string
  end
end
