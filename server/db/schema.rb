# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090522015607) do

  create_table "feed_items", :force => true do |t|
    t.string   "text"
    t.integer  "snapshot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
    t.string   "remote_id"
    t.string   "profile_image_url"
    t.string   "from_user"
    t.string   "from_user_id"
    t.string   "medium_image_url"
    t.boolean  "hidden",            :default => false, :null => false
  end

  create_table "reel_item_parts", :force => true do |t|
    t.integer  "reel_item_id", :null => false
    t.string   "media_url",    :null => false
    t.string   "media_type",   :null => false
    t.integer  "position",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reel_item_parts", ["reel_item_id"], :name => "index_reel_item_parts_on_reel_item_id"

  create_table "reel_items", :force => true do |t|
    t.string   "slug"
    t.string   "title"
    t.string   "credit"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "snapshots", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

end
