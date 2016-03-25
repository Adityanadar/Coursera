# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user_list = [
	['Carly', 'Fiorina', 'female', 1954],
	['Donald', 'Trump', 'male', 1946],
	['Ben', 'Carson', 'male', 1951],
	['Hillary', 'Clinton', 'female', 1947]
]

user_list.each do |first_name, last_name, gender, birth_year|
	user = User.create(username: last_name, password_digest: last_name.split('').shuffle.join + '123')	
	user.create_profile(first_name: first_name, last_name: last_name, gender: gender, birth_year: birth_year)
	user.todo_lists.create(list_due_date: Date.today + 1.year)
end

todoitem_list = [
	['Task 1', 'Buy milk'],
	['Task 2', 'Return library books'],
	['Task 3', 'Take out the trash'],
	['Task 4', 'Find good restaurants in London'],
	['Task 5', 'Clean fish tank'],
	['Task 6', 'Book flight to Rome'],
	['Task 7', 'Book flight to Rome'],
	['Task 8', 'Book flight to Rome'],
	['Task 9', 'Book flight to Rome'],
	['Task 10', 'Book flight to Rome'],
	['Task 11', 'Book flight to Rome'],
	['Task 12', 'Book flight to Rome'],
	['Task 13', 'Book flight to Rome'],
	['Task 14', 'Book flight to Rome'],
	['Task 15', 'Book flight to Rome'],
	['Task 16', 'Book flight to Rome'],
	['Task 17', 'Book flight to Rome'],
	['Task 18', 'Book flight to Rome'],
	['Task 19', 'Book flight to Rome'],
	['Task 20', 'Book flight to Rome']
]

new_todo = todoitem_list.each_slice(5).to_a

for i in 0..(TodoList.all.length-1)
	new_todo[i].each do |title, description|
		TodoItem.create(title: title, description: description, todo_list_id: TodoList.all[i].id, due_date: Date.today + 1.year)
	end
end
