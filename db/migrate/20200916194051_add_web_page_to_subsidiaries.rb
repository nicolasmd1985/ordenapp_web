class AddWebPageToSubsidiaries < ActiveRecord::Migration[5.2]
  def change
    add_column :subsidiaries, :web_page, :string
    add_column :subsidiaries, :principal_activity, :string
  end
end
