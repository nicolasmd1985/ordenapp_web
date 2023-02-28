class AddPriceToHistories < ActiveRecord::Migration[5.2]
  def change
    add_column :histories, :price, :integer
    add_column :histories, :warranty, :string
  end
end
