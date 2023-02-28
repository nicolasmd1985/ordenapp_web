class AddUrlavatarToSubsidiaries < ActiveRecord::Migration[5.2]
  def change
    add_column :subsidiaries, :urlavatar, :string
  end
end
