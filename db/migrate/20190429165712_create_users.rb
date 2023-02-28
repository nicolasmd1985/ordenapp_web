class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :identification
      t.string :first_name
      t.string :last_name
      t.string :auth_token
      # t.string :email
      t.string :phone_number
      t.string :company_name
      t.string :company_address

      t.timestamps
    end
  end
end
