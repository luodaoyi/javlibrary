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

ActiveRecord::Schema.define(version: 2017_11_20_130511) do

  create_table "actors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "actor_label"
    t.string "actor_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "javbus_label"
  end

  create_table "actors_users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "actor_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id", "user_id"], name: "index_actors_users_on_actor_id_and_user_id", unique: true
    t.index ["actor_id"], name: "index_actors_users_on_actor_id"
    t.index ["user_id"], name: "index_actors_users_on_user_id"
  end

  create_table "actors_videos", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "video_id"
    t.integer "actor_id"
    t.index ["actor_id"], name: "index_actors_videos_on_actor_id"
    t.index ["video_id"], name: "index_actors_videos_on_video_id"
  end

  create_table "genres", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres_videos", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "video_id"
    t.integer "genre_id"
    t.index ["genre_id"], name: "index_genres_videos_on_genre_id"
    t.index ["video_id"], name: "index_genres_videos_on_video_id"
  end

  create_table "labels", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "video_label"
    t.boolean "downloaded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "publisher"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stars", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "rank"
    t.string "img"
    t.string "actor_label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_videos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "video_id"
    t.index ["user_id", "video_id"], name: "index_users_videos_on_user_id_and_video_id", unique: true
    t.index ["user_id"], name: "index_users_videos_on_user_id"
    t.index ["video_id"], name: "index_users_videos_on_video_id"
  end

  create_table "videos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "video_id"
    t.string "video_name"
    t.string "release_date"
    t.string "length"
    t.string "director"
    t.string "maker"
    t.string "label"
    t.string "rating"
    t.string "img"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
