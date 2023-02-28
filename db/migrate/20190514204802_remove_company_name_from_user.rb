class RemoveCompanyNameFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :company_name
    remove_column :users, :company_address
  end
end
