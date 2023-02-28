class CreatePositionLogs < ActiveRecord::Migration[5.2]
  # destroy and redo this table if you need add new fields an there is nothing usefull on it
  def change
    create_table :position_logs do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.references :position, foreign_key: true

      t.timestamps
    end
  end
end
