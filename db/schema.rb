# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160510085504) do

  create_table "activities", force: :cascade do |t|
    t.integer  "product_backlog_id"
    t.string   "subject"
    t.string   "description"
    t.integer  "spent_time"
    t.integer  "estimate"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "activities", ["product_backlog_id"], name: "index_activities_on_product_backlog_id"

  create_table "assignees", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "sprint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "assignees", ["sprint_id"], name: "index_assignees_on_sprint_id"
  add_index "assignees", ["user_id"], name: "index_assignees_on_user_id"

  create_table "log_works", force: :cascade do |t|
    t.integer  "remaining_time"
    t.date     "day"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "phases", force: :cascade do |t|
    t.string   "phase_name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "product_backlogs", force: :cascade do |t|
    t.integer  "priority"
    t.float    "estimate"
    t.float    "actual"
    t.float    "remaining"
    t.integer  "project_id"
    t.integer  "sprint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "product_backlogs", ["project_id"], name: "index_product_backlogs_on_project_id"
  add_index "product_backlogs", ["sprint_id"], name: "index_product_backlogs_on_sprint_id"

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "manager_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "sprints", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "project_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "sprints", ["project_id"], name: "index_sprints_on_project_id"

  create_table "system_logs", force: :cascade do |t|
    t.string   "description"
    t.integer  "user_id"
    t.string   "action_type"
    t.integer  "target_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "time_logs", force: :cascade do |t|
    t.integer  "assignee_id"
    t.integer  "sprint_id"
    t.date     "work_date"
    t.integer  "lost_hour"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "time_logs", ["sprint_id"], name: "index_time_logs_on_sprint_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.integer  "role"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "work_performance_data", force: :cascade do |t|
    t.integer  "phase_id"
    t.string   "description"
    t.integer  "plan"
    t.integer  "actual"
    t.integer  "activity_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "work_performance_data", ["activity_id"], name: "index_work_performance_data_on_activity_id"
  add_index "work_performance_data", ["phase_id"], name: "index_work_performance_data_on_phase_id"

end
