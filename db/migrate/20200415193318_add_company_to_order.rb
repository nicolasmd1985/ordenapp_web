class AddCompanyToOrder < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :company, foreign_key: true
  end
end
