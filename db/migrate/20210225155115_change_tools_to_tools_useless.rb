class ChangeToolsToToolsUseless < ActiveRecord::Migration[5.2]
  def change
    rename_table :tools, :tool_useless
  end
end
