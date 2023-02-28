class AddPasswordToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :password, :string
  end
end
