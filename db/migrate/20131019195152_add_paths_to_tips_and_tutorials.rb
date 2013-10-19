class AddPathsToTipsAndTutorials < ActiveRecord::Migration
  def change
    add_column :tips,      :path, :string, default: '/', null: true
    add_column :tutorials, :path, :string, default: '/', null: true
  end
end
