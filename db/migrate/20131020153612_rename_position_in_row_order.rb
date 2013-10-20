class RenamePositionInRowOrder < ActiveRecord::Migration
  def change
    rename_column :tips, :position, :row_order
  end
end
