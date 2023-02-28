class AddIndexToThings < ActiveRecord::Migration[5.2]
  def change
    add_index :things, :code_scan
  end
end
