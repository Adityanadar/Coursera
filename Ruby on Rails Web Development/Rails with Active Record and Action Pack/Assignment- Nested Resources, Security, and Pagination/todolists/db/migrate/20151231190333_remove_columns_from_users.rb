class RemoveColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_reference :users, :profile, index: true, foreign_key: true
    remove_reference :users, :todo_lists, index: true, foreign_key: true
  end
end
