class RemoveStupidUniquenessIndexFromStates < ActiveRecord::Migration
  def up
    remove_index :states, :remote_user
    add_index :states,    :remote_user, unique: false
  end

  def down
    remove_index :states, :remote_user
    add_index :states,    :remote_user, unique: true
  end
end
