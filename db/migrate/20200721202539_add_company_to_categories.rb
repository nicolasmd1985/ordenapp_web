class AddCompanyToCategories < ActiveRecord::Migration[5.2]
  def change
    add_reference :categories, :company, foreign_key: true
  end
end
