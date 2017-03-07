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

ActiveRecord::Schema.define(version: 20170304184406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "answer",        null: false
    t.string   "question_type", null: false
    t.integer  "question_id",   null: false
    t.boolean  "is_correct",    null: false
    t.index ["question_type", "question_id"], name: "index_answers_on_question_type_and_question_id", using: :btree
  end

  create_table "cloze_sentences", force: :cascade do |t|
    t.string  "text",          null: false
    t.string  "question_type"
    t.integer "question_id"
    t.index ["question_type", "question_id"], name: "index_cloze_sentences_on_question_type_and_question_id", using: :btree
  end

  create_table "gaps", force: :cascade do |t|
    t.string   "gap_text"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "question_type", null: false
    t.integer  "question_id",   null: false
    t.index ["question_type", "question_id"], name: "index_gaps_on_question_type_and_question_id", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups_quizzes", id: false, force: :cascade do |t|
    t.integer "quiz_id",  null: false
    t.integer "group_id", null: false
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "user_id",  null: false
    t.integer "group_id", null: false
  end

  create_table "hints", force: :cascade do |t|
    t.string   "hint_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "gap_id"
  end

  create_table "pairs", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "question_type",                  null: false
    t.integer  "question_id",                    null: false
    t.string   "left_choice",       default: "", null: false
    t.string   "left_choice_uuid",  default: "", null: false
    t.string   "right_choice",      default: "", null: false
    t.string   "right_choice_uuid", default: "", null: false
    t.index ["question_type", "question_id"], name: "index_pairs_on_question_type_and_question_id", using: :btree
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "question",   null: false
    t.integer  "quiz_id"
    t.string   "type"
    t.index ["quiz_id"], name: "index_questions_on_quiz_id", using: :btree
  end

  create_table "quizzes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title",      null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_quizzes_on_user_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
  end

  create_table "sentences", force: :cascade do |t|
    t.string   "text"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "question_type", null: false
    t.integer  "question_id",   null: false
    t.boolean  "is_main"
    t.index ["question_type", "question_id"], name: "index_sentences_on_question_type_and_question_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "email"
    t.json     "tokens"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

end
