class AddCompanyToThing < ActiveRecord::Migration[5.2]
  def change
    add_reference :things, :company, foreign_key: true
    add_column :things, :maintenance_frecuency_type, :string
    add_column :things, :maintenance_quantity, :integer
    add_column :things, :slug, :string
  end
end
