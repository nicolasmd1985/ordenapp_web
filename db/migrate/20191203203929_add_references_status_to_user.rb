class AddReferencesStatusToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :status, foreign_key: true
  end
end
