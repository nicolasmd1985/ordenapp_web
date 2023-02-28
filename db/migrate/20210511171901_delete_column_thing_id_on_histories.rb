class DeleteColumnThingIdOnHistories < ActiveRecord::Migration[5.2]
  def change
    remove_column :histories, :thing_id
  end
end
