class CreateTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
      t.references :site, index: true
      t.string :title
      t.datetime :published_at
      t.datetime :unpublished_at

      t.timestamps
    end
  end
end
