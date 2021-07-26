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

ActiveRecord::Schema.define(version: 2020_01_18_231447) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounting_records", force: :cascade do |t|
    t.string "detail"
    t.decimal "debit", precision: 8, scale: 2
    t.decimal "credit", precision: 8, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "invoice_id"
    t.integer "user_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "name"
    t.decimal "price_cost", precision: 8, scale: 2
    t.decimal "percentaje", precision: 8, scale: 2
    t.decimal "price_total", precision: 8, scale: 2
    t.decimal "quantity", precision: 8, scale: 2
    t.string "barcode"
    t.integer "supplier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "brand_id"
    t.integer "category_id", default: 1
    t.boolean "allow_negative", default: false
    t.decimal "minimum_stock", precision: 8, scale: 2
    t.decimal "quantity_package", precision: 8, scale: 2
    t.decimal "iva", precision: 4, scale: 2
    t.boolean "allow_change_price", default: false
    t.string "code_supplier"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.tsvector "tsv"
    t.index ["id"], name: "index_articles_on_id"
    t.index ["tsv"], name: "index_articles_on_tsv", using: :gin
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "current_accounts", force: :cascade do |t|
    t.integer "customer_id"
    t.string "detail"
    t.decimal "debit", precision: 8, scale: 2
    t.decimal "credit", precision: 8, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "invoice_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "lastname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "deadlines", force: :cascade do |t|
    t.date "due_date"
    t.bigint "article_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "stock_id"
    t.index ["article_id"], name: "index_deadlines_on_article_id"
  end

  create_table "invoice_stocks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "price_total", precision: 8, scale: 2
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "customer_id"
    t.decimal "price_total", precision: 8, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.decimal "subtotal", precision: 8, scale: 2
    t.decimal "discount", precision: 8, scale: 2
  end

  create_table "orders", force: :cascade do |t|
    t.integer "article_id"
    t.decimal "quantity"
    t.decimal "price_unit", precision: 8, scale: 2
    t.decimal "price_total", precision: 8, scale: 2
    t.integer "invoice_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "discount", precision: 8, scale: 2
    t.string "name"
    t.decimal "price_cost"
    t.decimal "profit"
    t.index ["id"], name: "index_orders_on_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.bigint "article_id"
    t.decimal "quantity", precision: 8, scale: 2
    t.decimal "price_cost", precision: 8, scale: 2
    t.bigint "supplier_id"
    t.bigint "invoice_stock_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_total"
    t.integer "category_id"
    t.decimal "iva", precision: 4, scale: 2
    t.integer "quantity_labels"
    t.index ["article_id"], name: "index_stocks_on_article_id"
    t.index ["invoice_stock_id"], name: "index_stocks_on_invoice_stock_id"
    t.index ["supplier_id"], name: "index_stocks_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "update_process_articles", force: :cascade do |t|
    t.bigint "supplier_id"
    t.integer "updated"
    t.integer "failed"
    t.bigint "user_id"
    t.float "percentage"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["supplier_id"], name: "index_update_process_articles_on_supplier_id"
    t.index ["user_id"], name: "index_update_process_articles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "username"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role", default: "invitado"
    t.boolean "is_deleted", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
