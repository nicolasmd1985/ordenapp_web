class AddSubstatusToThings < ActiveRecord::Migration[5.2]
  def change
    add_reference :things, :substatus, foreign_key: true, optional: true
  end
end
