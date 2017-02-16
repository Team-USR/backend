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

ActiveRecord::Schema.define(version: 20170216180406) do

  create_table "answers", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "answer",      null: false
    t.integer  "question_id", null: false
    t.boolean  "is_correct",  null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
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
    t.index ["question_type", "question_id"], name: "index_pairs_on_question_type_and_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "question",   null: false
    t.integer  "quiz_id"
    t.string   "type"
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title",      null: false
  end

  create_table "sentences", force: :cascade do |t|
    t.string   "text"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "question_type", null: false
    t.integer  "question_id",   null: false
    t.boolean  "is_main"
    t.index ["question_type", "question_id"], name: "index_sentences_on_question_type_and_question_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
