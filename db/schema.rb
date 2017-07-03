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

ActiveRecord::Schema.define(version: 20170703122535) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  end

  create_table "campaign_users", force: :cascade do |t|
    t.integer  "campaign_id"
    t.integer  "user_id"
    t.string   "status",      default: "draft"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "sent_at"
    t.index ["campaign_id", "user_id"], name: "index_campaign_users_on_campaign_id_and_user_id", unique: true, using: :btree
    t.index ["campaign_id"], name: "index_campaign_users_on_campaign_id", using: :btree
    t.index ["user_id"], name: "index_campaign_users_on_user_id", using: :btree
  end

  create_table "campaigns", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "name"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "email_template_id"
    t.index ["account_id"], name: "index_campaigns_on_account_id", using: :btree
    t.index ["email_template_id"], name: "index_campaigns_on_email_template_id", using: :btree
  end

  create_table "email_templates", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_email_templates_on_account_id", using: :btree
  end

  create_table "imap_settings", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "address"
    t.string   "port"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_imap_settings_on_account_id", using: :btree
  end

  create_table "smtp_settings", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "from_email"
    t.string   "reply_to"
    t.string   "provider"
    t.string   "address"
    t.string   "port"
    t.string   "domain"
    t.string   "username"
    t.string   "password"
    t.boolean  "is_default", default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["account_id"], name: "index_smtp_settings_on_account_id", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "user_attributes", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_attributes_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "email"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_users_on_account_id", using: :btree
    t.index ["email"], name: "index_users_on_email", using: :btree
  end

  add_foreign_key "campaign_users", "campaigns"
  add_foreign_key "campaign_users", "users"
  add_foreign_key "campaigns", "accounts"
  add_foreign_key "campaigns", "email_templates"
  add_foreign_key "email_templates", "accounts"
  add_foreign_key "imap_settings", "accounts"
  add_foreign_key "smtp_settings", "accounts"
  add_foreign_key "user_attributes", "users"
end
