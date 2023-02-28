class CreateReferrals < ActiveRecord::Migration[5.2]
  def change
    create_table :referrals do |t|
      t.text :comment
      t.text :signature
      t.string :full_name
      t.timestamp :final_time
      t.string :email
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
