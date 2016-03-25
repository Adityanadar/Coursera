class RemoveColumnsFromTodoLists < ActiveRecord::Migration
  def change
    remove_reference :todo_lists, :todo_items, index: true, foreign_key: true
  end
end
