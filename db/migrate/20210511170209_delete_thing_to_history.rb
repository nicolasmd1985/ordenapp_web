class DeleteThingToHistory < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :histories, :things
  end
end
