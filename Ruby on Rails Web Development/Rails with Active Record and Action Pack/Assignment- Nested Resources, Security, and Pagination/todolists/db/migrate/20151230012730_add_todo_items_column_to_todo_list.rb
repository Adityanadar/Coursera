class AddTodoItemsColumnToTodoList < ActiveRecord::Migration
  def change
    add_reference :todo_lists, :todo_items, index: true, foreign_key: true
  end
end
