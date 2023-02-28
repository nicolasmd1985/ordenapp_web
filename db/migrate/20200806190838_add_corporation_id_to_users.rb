class AddCorporationIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :corporation, foreign_key: true, optional: true
  end
end
