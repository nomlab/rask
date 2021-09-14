# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = User.create!([
                      { name: 'user1', email: 'example@example.com', password: User.digest('password') },
                      { name: 'user2', email: 'example2@example.com', password: User.digest('password') }
                    ])

projects = Project.create!([
                 { name: 'project1', user_id: users.first.id },
                 { name: 'project2', user_id: users.first.id }
               ])

status = State.create!([
                 { name: 'todo', priority: 1, color: "red", about:"やるべき Task"},
                 { name: 'done', priority: 0, color: "black", about:"完了した Task"},
                 { name: 'draft', priority: 2, color: "glay", about:"書きかけの Task"},
                ])

Task.create!([
              { content: 'task1', description: 'desc1', due_at: '2021-07-16 12:22:22', creator_id: users.first.id, assigner_id: users.first.id, project_id: projects.first.id, status: status.first.id},
              { content: 'task2', description: 'desc2', due_at: '2021-07-16 12:22:22', creator_id: users.first.id, assigner_id: users.first.id, project_id: projects.first.id, status: status.first.id},
            ])