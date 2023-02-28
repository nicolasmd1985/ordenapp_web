class AddSubstatusToHistory < ActiveRecord::Migration[5.2]
  def change
    add_reference :histories, :substatus, foreign_key: true, optional: true
  end
end
