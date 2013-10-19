class AddSelectorAndPositionToTip < ActiveRecord::Migration
  def change

    add_column :tips, :selector, :text # For good measure, let's not stop at 256 chars if we end up using xpath.

    add_column :tips, :position, :integer, default: 0, null: false
  end
end
