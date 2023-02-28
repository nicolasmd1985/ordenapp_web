class RemoveFinalAddressFromThings < ActiveRecord::Migration[5.2]
  def change
    remove_column :things, :initial_address
    remove_column :things, :final_address
    add_column :things, :position_ids, :string, default: [].to_yaml
  end
end
