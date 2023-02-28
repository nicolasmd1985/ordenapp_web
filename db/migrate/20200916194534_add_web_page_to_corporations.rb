class AddWebPageToCorporations < ActiveRecord::Migration[5.2]
  def change
    add_column :corporations, :web_page, :string
    add_column :corporations, :principal_activity, :string
  end
end
