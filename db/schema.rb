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

ActiveRecord::Schema.define(version: 2019_03_28_163401) do

  create_table "characteristics", force: :cascade do |t|
    t.string "category"
    t.integer "pattern_id"
    t.string "title"
    t.text "body"
    t.text "chara_1_str"
    t.integer "chara_1_val"
    t.text "chara_2_str"
    t.integer "chara_2_val"
    t.text "chara_3_str"
    t.integer "chara_3_val"
    t.text "chara_4_str"
    t.integer "chara_4_val"
    t.text "chara_5_str"
    t.integer "chara_5_val"
    t.integer "item_1"
    t.integer "item_2"
    t.integer "item_3"
    t.integer "item_4"
    t.integer "item_5"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer "item_id"
    t.string "maker"
    t.text "name"
    t.integer "price"
    t.integer "shop_num"
    t.integer "rank"
    t.decimal "satisfaction"
    t.integer "quote"
    t.integer "revier"
    t.decimal "inch"
    t.text "resolution"
    t.boolean "wide"
    t.boolean "touchpannel"
    t.boolean "twoinone"
    t.text "cpu_name"
    t.decimal "cpu_clockspeed"
    t.integer "cpu_core"
    t.integer "cpu_score"
    t.integer "hdd"
    t.integer "hdd_speed"
    t.integer "ssd"
    t.integer "emmc"
    t.integer "ram"
    t.text "ram_type"
    t.integer "ram_empty_clot"
    t.text "gpu_name"
    t.integer "gpu_ram"
    t.boolean "drive"
    t.boolean "dvd"
    t.boolean "blueray"
    t.boolean "wireless"
    t.boolean "lan"
    t.boolean "cellular"
    t.boolean "wifi_direct"
    t.boolean "nfc"
    t.boolean "faceprint"
    t.boolean "fingerprint"
    t.boolean "webcamera"
    t.boolean "bluetooth"
    t.boolean "tenkey"
    t.boolean "touchpen"
    t.boolean "gamingpc"
    t.boolean "fanless"
    t.integer "hdmi"
    t.integer "minihdmi"
    t.integer "minidisplay"
    t.integer "vga"
    t.integer "usb_a"
    t.integer "usb_c"
    t.boolean "sd"
    t.boolean "microsd"
    t.text "os"
    t.text "office"
    t.decimal "uptime"
    t.decimal "weight"
    t.text "color"
    t.date "date_sale"
    t.text "series"
    t.text "sirial"
    t.text "affiliate"
    t.text "image"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "match_id"
    t.string "category"
    t.integer "option_id"
    t.string "item_clmn"
    t.float "min"
    t.float "max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "option_results", force: :cascade do |t|
    t.integer "user_id"
    t.string "category"
    t.integer "question_id"
    t.integer "option_id"
    t.boolean "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", force: :cascade do |t|
    t.integer "option_id"
    t.string "category"
    t.integer "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.integer "next_question_id"
    t.integer "remain_question_num"
  end

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "question_id"
    t.integer "remain_question_num"
  end

  create_table "results", force: :cascade do |t|
    t.integer "user_id"
    t.integer "question_id"
    t.boolean "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
  end

  create_table "userpatterns", force: :cascade do |t|
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

  create_table "users", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
