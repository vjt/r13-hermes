class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.references :tippable, polymorphic: true, index: true
      t.string :title
      t.text :content
      t.datetime :published_at
      t.datetime :unpublished_at

      t.timestamps
    end
  end
end
