class RemoveFkFromTools < ActiveRecord::Migration[5.2]
  def change
    if foreign_key_exists?(:tools, :users)
      remove_foreign_key :tools, :users
    end
    if foreign_key_exists?(:tools, :statuses)
      remove_foreign_key :tools, :statuses
    end
    if foreign_key_exists?(:tools, :subsidiaries)
      remove_foreign_key :tools, :subsidiaries
    end
  end
end
