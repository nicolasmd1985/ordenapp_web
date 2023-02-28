class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :slug
      t.string :order_internal_id
      t.string :order_status
      t.string :order_slug
      t.datetime :read_at
      t.boolean :readed, default: false
      t.integer :supervisor_id
      t.string :supervisor_name
      t.integer :user_id
      t.string :user_name
      t.timestamps

      t.references :subsidiary, foreign_key: true
    end

    add_index :notifications, :slug
    add_index :notifications, :supervisor_id
    add_index :notifications, :user_id
  end
end
