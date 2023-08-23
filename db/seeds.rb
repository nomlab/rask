# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
task_states = TaskState.create!([
                                  { name: 'todo', priority: 1, color: "red", about:"やるべき Task"},
                                  { name: 'done', priority: 0, color: "black", about:"完了した Task"},
                                  { name: 'draft', priority: 2, color: "gray", about:"書きかけの Task"},
                                ])

users = User.create!([
                       { name: 'User1 Name', screen_name: 'user1' },
                       { name: 'User2 Name', screen_name: 'user2' }
                     ])

projects = Project.create!([
                             { name: 'project1', user_id: users.first.id },
                             { name: 'project2', user_id: users.first.id }
                           ])

Task.create!([
               { content: 'task1', description: 'desc1', due_at: '2021-07-16 12:22:22', creator_id: users.first.id, assigner_id: users.first.id, project_id: projects.first.id, task_state_id: task_states.first.id },
               { content: 'task2', description: 'desc2', due_at: '2021-07-16 12:22:22', creator_id: users.first.id, assigner_id: users.first.id, project_id: projects.first.id, task_state_id: task_states.first.id },
             ])