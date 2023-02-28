class ChangeCompaniesToSubsidiaries < ActiveRecord::Migration[5.2]
  def change
    rename_table :companies, :subsidiaries
  end
end
