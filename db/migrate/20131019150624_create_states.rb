class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|

      t.references :message, :polymorphic => true
      t.timestamp  :show_at
      t.string     :remote_user
    end

    add_index :states, [:message_id, :message_type]
    add_index :states, :remote_user, unique: true
    add_index :states, :show_at
  end
end
