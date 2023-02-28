class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.string :action
      t.string :username
      t.string :status_description
      t.string :data_log, limit: 2000, default: [].to_yaml

      t.references :order, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
