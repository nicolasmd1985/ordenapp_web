class AddCompanyNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :company_name, :string
    add_column :users, :principal_activity, :string
    add_column :users, :priority_user, :text
    add_column :users, :web_page, :string
  end
end
