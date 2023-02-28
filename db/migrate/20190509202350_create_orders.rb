class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|

      
      t.string :description
      t.string :address
      t.integer :priority
      t.datetime :initial_time
      t.datetime :final_time
      t.datetime :limit_time
      t.boolean :sync

      t.timestamps
    end



    
  end
end
