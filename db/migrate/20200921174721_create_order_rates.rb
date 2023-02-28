class CreateOrderRates < ActiveRecord::Migration[5.2]
  def change
    create_table :order_rates do |t|
      t.text :comments, optional: true
      t.string :slug
      t.boolean :active, default: true
      t.string :question_1
      t.string :question_2
      t.string :question_3
      t.string :question_4
      t.string :question_5
      t.integer :answer_1
      t.integer :answer_2
      t.integer :answer_3
      t.integer :answer_4
      t.integer :answer_5
      t.integer :month
      t.integer :year

      t.references :user, foreign_key: true
      t.references :order, foreign_key: true
      t.references :subsidiary, foreign_key: true

      t.timestamps
    end
  end
end
