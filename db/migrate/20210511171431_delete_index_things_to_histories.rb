class DeleteIndexThingsToHistories < ActiveRecord::Migration[5.2]
  def change
    remove_index :histories, :thing_id
  end
end
