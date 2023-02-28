class ChangeCompanyInitialForSubsidiaries < ActiveRecord::Migration[5.2]
  def change
    rename_column :subsidiaries, :company_initials, :subsidiary_initials
  end
end
