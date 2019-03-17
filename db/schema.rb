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

ActiveRecord::Schema.define(version: 2019_03_16_123449) do

  create_table "patterns", force: :cascade do |t|
    t.string "category"
    t.integer "pattern_id"
    t.boolean "answer_1"
    t.boolean "answer_2"
    t.boolean "answer_3"
    t.boolean "answer_4"
    t.boolean "answer_5"
    t.boolean "answer_6"
    t.boolean "answer_7"
    t.boolean "answer_8"
    t.boolean "answer_9"
    t.boolean "answer_10"
    t.boolean "answer_11"
    t.boolean "answer_12"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "category"
    t.text "content"
    t.boolean "option"
    t.integer "option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "results", force: :cascade do |t|
    t.integer "user_id"
    t.integer "question_id"
    t.boolean "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
