class CreateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :statuses do |t|
      t.string :type_status
      t.string :description

      t.timestamps
    end
  end
end
