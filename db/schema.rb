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

ActiveRecord::Schema.define(version: 20150528200305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "checkouts", force: :cascade do |t|
    t.integer  "user_id",          null: false
    t.integer  "plan_id",          null: false
    t.string   "stripe_coupon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkouts", ["plan_id"], name: "index_checkouts_on_plan_id", using: :btree
  add_index "checkouts", ["user_id"], name: "index_checkouts_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.string   "email",        null: false
    t.string   "code",         null: false
    t.datetime "accepted_at"
    t.integer  "sender_id",    null: false
    t.integer  "recipient_id"
    t.integer  "team_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["code"], name: "index_invitations_on_code", using: :btree
  add_index "invitations", ["team_id"], name: "index_invitations_on_team_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name",                              null: false
    t.string   "sku",                               null: false
    t.string   "short_description",                 null: false
    t.text     "description",                       null: false
    t.boolean  "active",            default: true,  null: false
    t.integer  "price_in_dollars",                  null: false
    t.text     "terms"
    t.boolean  "featured",          default: false, null: false
    t.boolean  "annual",            default: false
    t.integer  "annual_plan_id"
    t.integer  "minimum_quantity",  default: 1,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "includes_team",     default: false, null: false
  end

  add_index "plans", ["annual_plan_id"], name: "index_plans_on_annual_plan_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "sku"
    t.string   "tagline"
    t.string   "call_to_action"
    t.string   "short_description"
    t.text     "description"
    t.string   "type",                                       null: false
    t.boolean  "active"
    t.text     "questions"
    t.text     "terms"
    t.text     "alternative_description"
    t.string   "product_image_file_name"
    t.string   "product_image_file_size"
    t.string   "product_image_content_type"
    t.string   "product_image_updated_at"
    t.boolean  "promoted",                   default: false, null: false
    t.string   "slug",                                       null: false
    t.text     "resources",                  default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["slug"], name: "index_products_on_slug", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "deactivated_on"
    t.date     "scheduled_for_cancellation_on"
    t.integer  "plan_id"
    t.string   "plan_type",                     default: "IndividualPlan", null: false
    t.decimal  "next_payment_amount",           default: 0.0,              null: false
    t.date     "next_payment_on"
    t.string   "stripe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "card_type"
    t.string   "card_last_four_digits"
    t.date     "card_expires_on"
    t.datetime "trial_ends_at"
  end

  add_index "subscriptions", ["plan_id"], name: "index_subscriptions_on_plan_id", using: :btree
  add_index "subscriptions", ["stripe_id"], name: "index_subscriptions_on_stripe_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",            null: false
    t.integer  "subscription_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["subscription_id"], name: "index_teams_on_subscription_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",         null: false
    t.string   "encrypted_password",     default: "",         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "role",                   default: "standard"
    t.string   "authentication_token"
    t.string   "profile_image"
    t.string   "stripe_customer_id",     default: "",         null: false
    t.string   "organization"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "country"
    t.integer  "team_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["team_id"], name: "index_users_on_team_id", using: :btree

  add_foreign_key "checkouts", "plans"
  add_foreign_key "checkouts", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "invitations", "teams"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "teams", "subscriptions"
end
