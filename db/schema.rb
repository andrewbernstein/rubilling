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

ActiveRecord::Schema[8.1].define(version: 2026_07_17_023159) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "adjustments", force: :cascade do |t|
    t.string "adjustment_type"
    t.integer "amount_in_cents"
    t.bigint "applied_transaction_id"
    t.datetime "created_at", null: false
    t.bigint "invoice_id"
    t.bigint "line_item_id"
    t.datetime "updated_at", null: false
  end

  create_table "applied_transactions", force: :cascade do |t|
    t.integer "amount_in_cents"
    t.datetime "created_at", null: false
    t.bigint "invoice_id"
    t.bigint "transaction_id"
    t.datetime "updated_at", null: false
  end

  create_table "entities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "external_id"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "external_id"
    t.bigint "parent_invoice_id"
    t.bigint "payee_id"
    t.string "shortcode"
    t.datetime "updated_at", null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "invoice_id"
    t.integer "quantity"
    t.datetime "updated_at", null: false
    t.bigint "variant_id"
  end

  create_table "logs", force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.text "error"
    t.text "error_stack"
    t.json "parameters"
    t.bigint "parent_log_id"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "payment_methods", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "entity_id"
    t.string "payment_processor"
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "amount_in_cents"
    t.datetime "created_at", null: false
    t.bigint "payment_method_id"
    t.datetime "updated_at", null: false
  end

  create_table "variants", force: :cascade do |t|
    t.integer "amount_in_cents"
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "product_id"
    t.datetime "updated_at", null: false
  end
end
