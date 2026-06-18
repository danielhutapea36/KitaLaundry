# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_18_082821) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "address_type"
    t.string "city"
    t.datetime "created_at", null: false
    t.text "full_address"
    t.boolean "is_default"
    t.string "landmark"
    t.float "latitude"
    t.float "longitude"
    t.string "phone"
    t.string "pincode"
    t.string "state"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "branches", force: :cascade do |t|
    t.text "address"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "phone"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_read", default: false
    t.text "message"
    t.string "notification_type"
    t.string "reference_id"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "order_id", null: false
    t.bigint "service_id", null: false
    t.datetime "updated_at", null: false
    t.decimal "weight_kg", precision: 8, scale: 2, null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["service_id"], name: "index_order_items_on_service_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "branch_id", null: false
    t.datetime "created_at", null: false
    t.bigint "delivery_address_id"
    t.string "invoice_url"
    t.text "notes"
    t.string "payment_method"
    t.integer "payment_status", default: 0
    t.bigint "pickup_address_id"
    t.integer "status", default: 0
    t.integer "total_price", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "xendit_invoice_id"
    t.index ["branch_id"], name: "index_orders_on_branch_id"
    t.index ["delivery_address_id"], name: "index_orders_on_delivery_address_id"
    t.index ["pickup_address_id"], name: "index_orders_on_pickup_address_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "branch_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "price_per_kg", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_services_on_branch_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.datetime "email_verified_at"
    t.string "first_name"
    t.string "last_name"
    t.string "password_digest"
    t.string "phone"
    t.integer "role"
    t.datetime "updated_at", null: false
    t.string "verification_token"
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "services"
  add_foreign_key "orders", "addresses", column: "delivery_address_id"
  add_foreign_key "orders", "addresses", column: "pickup_address_id"
  add_foreign_key "orders", "branches"
  add_foreign_key "orders", "users"
  add_foreign_key "services", "branches"
end
