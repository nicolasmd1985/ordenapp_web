class CreateToolComments < ActiveRecord::Migration[5.2]
  def change
    create_table :tool_comments do |t|
      t.text :comment
      t.references :user, foreign_key: true
      t.references :tool, foreign_key: true

      t.timestamps
    end
  end
end
