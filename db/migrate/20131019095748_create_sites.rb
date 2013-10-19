class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.references :user
      t.string :name
      t.string :url
      t.text :description
      t.string :verification_token
      t.datetime :verified_at

      t.timestamps
    end
  end
end
