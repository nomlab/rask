# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_12_19_065934) do

  create_table "action_items", force: :cascade do |t|
    t.integer "uid"
    t.string "task_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "api_tokens", force: :cascade do |t|
    t.string "secret"
    t.string "description"
    t.datetime "expired_at"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "document_tags", id: false, force: :cascade do |t|
    t.integer "document_id", null: false
    t.integer "tag_id", null: false
    t.index ["document_id"], name: "index_document_tags_on_document_id"
    t.index ["tag_id"], name: "index_document_tags_on_tag_id"
  end

  create_table "documents", force: :cascade do |t|
    t.text "content", null: false
    t.integer "creator_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer "assigner_id"
    t.text "description"
    t.integer "project_id"
    t.text "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "keyword"
    t.index ["project_id"], name: "index_documents_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "task_states", force: :cascade do |t|
    t.string "name"
    t.integer "priority"
    t.string "about"
    t.string "color"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "task_tags", force: :cascade do |t|
    t.integer "task_id"
    t.integer "tag_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_id"], name: "index_task_tags_on_tag_id"
    t.index ["task_id"], name: "index_task_tags_on_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.text "content", null: false
    t.integer "creator_id"
    t.datetime "due_at"
    t.integer "assigner_id"
    t.text "description"
    t.integer "project_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "tag_id"
    t.integer "task_state_id"
    t.text "keyword"
    t.index ["project_id"], name: "index_tasks_on_project_id"
    t.index ["tag_id"], name: "index_tasks_on_tag_id"
    t.index ["task_state_id"], name: "index_tasks_on_task_state_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "screen_name"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "uid"
    t.string "avatar_url"
    t.index ["screen_name"], name: "index_users_on_screen_name", unique: true
  end

  add_foreign_key "api_tokens", "users", on_delete: :cascade
  add_foreign_key "document_tags", "documents"
  add_foreign_key "document_tags", "tags"
  add_foreign_key "documents", "projects"
  add_foreign_key "documents", "projects", on_delete: :cascade
  add_foreign_key "documents", "users", column: "assigner_id", on_delete: :cascade
  add_foreign_key "documents", "users", column: "creator_id", on_delete: :cascade
  add_foreign_key "projects", "users"
  add_foreign_key "projects", "users", on_delete: :cascade
  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks", "projects", on_delete: :cascade
  add_foreign_key "tasks", "tags"
  add_foreign_key "tasks", "task_states"
  add_foreign_key "tasks", "users", column: "assigner_id", on_delete: :cascade
  add_foreign_key "tasks", "users", column: "creator_id", on_delete: :cascade
end
