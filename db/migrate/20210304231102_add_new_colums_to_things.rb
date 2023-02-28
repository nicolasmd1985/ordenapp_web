class AddNewColumsToThings < ActiveRecord::Migration[5.2]
  def change
    add_column :things, :final_price, :decimal, :precision => 15, :scale => 2
    add_column :things, :cost_price, :decimal, :precision => 15, :scale => 2
    add_column :things, :stock, :integer
    add_column :things, :weight, :integer
    add_column :things, :unit_weight, :string
    add_column :things, :serial_number, :integer
    add_column :things, :start_warranty, :datetime
    add_column :things, :finish_warranty, :datetime
    add_column :things, :urlavatar, :string
    add_column :things, :start_time, :datetime
  end
end
