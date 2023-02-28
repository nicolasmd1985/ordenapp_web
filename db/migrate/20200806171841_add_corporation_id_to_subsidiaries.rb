class AddCorporationIdToSubsidiaries < ActiveRecord::Migration[5.2]
  def change
    add_reference :subsidiaries, :corporation, foreign_key: true
  end
end
