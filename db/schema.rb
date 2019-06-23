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

ActiveRecord::Schema.define(version: 2019_06_23_000243) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "preview"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "category_id"
    t.string "category"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "columns", force: :cascade do |t|
    t.string "category"
    t.string "column_name"
    t.string "frendly_name"
    t.string "unit"
    t.boolean "available"
    t.boolean "dsc_better"
    t.boolean "fundamental"
    t.boolean "remove"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "item_info"
  end

  create_table "images", force: :cascade do |t|
    t.string "name"
    t.string "image"
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
    t.string "category"
    t.integer "volume"
    t.integer "gpu_score"
    t.boolean "windows"
    t.boolean "mac"
    t.boolean "chrome"
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

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.text "outline"
    t.string "director"
    t.text "performer"
    t.integer "year"
    t.string "preview"
    t.string "image"
    t.string "article"
    t.string "movie"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "youtube"
    t.string "netflix"
    t.string "amazonprime"
    t.string "hulu"
    t.string "filmarks"
  end

  create_table "options", force: :cascade do |t|
    t.integer "option_id"
    t.string "category"
    t.integer "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.integer "next_question_id"
  end

  create_table "pcs", force: :cascade do |t|
    t.integer "item_id"
    t.string "category"
    t.string "maker"
    t.text "name"
    t.integer "price"
    t.integer "shop_num"
    t.integer "rank"
    t.decimal "satisfaction"
    t.integer "quote"
    t.integer "revier"
    t.decimal "inch"
    t.string "resolution"
    t.boolean "wide"
    t.boolean "touchpannel"
    t.boolean "twoinone"
    t.string "case"
    t.string "cpu_name"
    t.decimal "cpu_clockspeed"
    t.integer "cpu_core"
    t.integer "cpu_score"
    t.integer "hdd"
    t.integer "hdd_speed"
    t.integer "ssd"
    t.integer "emmc"
    t.integer "optane"
    t.integer "ram"
    t.integer "volume"
    t.integer "ram_max"
    t.string "ram_type"
    t.integer "ram_all_slot"
    t.integer "ram_empty_clot"
    t.string "gpu_name"
    t.integer "gpu_ram"
    t.integer "gpu_score"
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
    t.boolean "output_4k"
    t.boolean "watercool"
    t.boolean "tv_tuner"
    t.boolean "tv_tuner_4k"
    t.integer "hdmi"
    t.integer "minihdmi"
    t.integer "minidisplay"
    t.integer "vga"
    t.integer "usb_a"
    t.integer "usb_c"
    t.boolean "sd"
    t.boolean "microsd"
    t.string "os"
    t.boolean "windows"
    t.boolean "mac"
    t.boolean "chrome"
    t.string "office"
    t.decimal "uptime"
    t.decimal "weight"
    t.string "color"
    t.date "date_sale"
    t.string "series"
    t.string "sirial"
    t.text "affiliate"
    t.text "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "ex_gpu"
    t.boolean "microsoftoffice"
    t.integer "cluster_1"
    t.integer "cluster_2"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.boolean "result"
    t.integer "option_id"
    t.integer "times"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "movie_id"
    t.index ["movie_id"], name: "index_tags_on_movie_id"
  end

  create_table "temp_users", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "toiletpaper_items", force: :cascade do |t|
    t.integer "item_id"
    t.string "category"
    t.string "maker"
    t.text "name"
    t.integer "price"
    t.boolean "single"
    t.boolean "double"
    t.integer "cost"
    t.integer "soft"
    t.integer "flavor"
    t.integer "smooth"
    t.integer "water"
    t.boolean "design"
    t.integer "fun"
    t.text "series"
    t.text "affiliate"
    t.text "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
