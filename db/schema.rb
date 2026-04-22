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

ActiveRecord::Schema[8.1].define(version: 2026_04_22_202842) do
  create_table "accounts_payable", id: :string, force: :cascade do |t|
    t.string "aasm_state", default: "", null: false
    t.integer "amount_cents", null: false
    t.string "category", default: "", null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "", null: false
    t.string "description", null: false
    t.string "document_number", null: false
    t.date "due_date", null: false
    t.string "nanoid", null: false
    t.text "notes"
    t.date "paid_at"
    t.integer "paid_cents", null: false
    t.string "supplier_id"
    t.datetime "updated_at", null: false
    t.index ["due_date"], name: "index_accounts_payable_on_due_date"
    t.index ["nanoid"], name: "index_accounts_payable_on_nanoid", unique: true
    t.index ["supplier_id"], name: "index_accounts_payable_on_supplier_id"
  end

  create_table "accounts_receivable", id: :string, force: :cascade do |t|
    t.string "aasm_state", default: "", null: false
    t.integer "amount_cents", null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "", null: false
    t.string "customer_id"
    t.string "document_number", null: false
    t.date "due_date", null: false
    t.decimal "interest_rate", precision: 5, scale: 4
    t.string "nanoid", null: false
    t.text "notes"
    t.date "paid_at"
    t.integer "paid_cents", null: false
    t.string "sale_id"
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_accounts_receivable_on_customer_id"
    t.index ["due_date"], name: "index_accounts_receivable_on_due_date"
    t.index ["nanoid"], name: "index_accounts_receivable_on_nanoid", unique: true
    t.index ["sale_id"], name: "index_accounts_receivable_on_sale_id"
  end

  create_table "active_storage_attachments", id: :string, default: -> { "nanoid(21)" }, force: :cascade do |t|
    t.string "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :string, default: -> { "nanoid(21)" }, force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :string, default: -> { "nanoid(21)" }, force: :cascade do |t|
    t.string "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", id: :string, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "discarded_at"
    t.string "icon", default: ""
    t.string "name", null: false
    t.string "nanoid", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_categories_on_discarded_at"
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["nanoid"], name: "index_categories_on_nanoid", unique: true
  end

  create_table "customers", id: :string, force: :cascade do |t|
    t.string "address"
    t.date "birthday"
    t.string "city"
    t.string "cpf_cnpj"
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "email"
    t.string "name", null: false
    t.string "nanoid", null: false
    t.text "notes"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.string "whatsapp"
    t.string "zip_code"
    t.index ["cpf_cnpj"], name: "index_customers_on_cpf_cnpj", unique: true, where: "cpf_cnpj IS NOT NULL"
    t.index ["discarded_at"], name: "index_customers_on_discarded_at"
    t.index ["nanoid"], name: "index_customers_on_nanoid", unique: true
  end

  create_table "groups", id: :string, force: :cascade do |t|
    t.string "code", limit: 32
    t.datetime "created_at", null: false
    t.boolean "enabled", default: true
    t.string "name", limit: 128
    t.string "nanoid", null: false
    t.datetime "updated_at", null: false
    t.index ["nanoid"], name: "index_groups_on_nanoid", unique: true
  end

  create_table "movements", id: :string, force: :cascade do |t|
    t.integer "cost_cents", null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "", null: false
    t.string "document_ref"
    t.string "kind", null: false
    t.string "nanoid", null: false
    t.string "product_id", null: false
    t.decimal "quantity", null: false
    t.string "reason"
    t.string "sale_id"
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["kind"], name: "index_movements_on_kind"
    t.index ["nanoid"], name: "index_movements_on_nanoid", unique: true
    t.index ["product_id"], name: "index_movements_on_product_id"
    t.index ["sale_id"], name: "index_movements_on_sale_id"
    t.index ["user_id"], name: "index_movements_on_user_id"
  end

  create_table "products", id: :string, force: :cascade do |t|
    t.string "aasm_state", default: "", null: false
    t.string "barcode"
    t.string "brand"
    t.string "category_id", null: false
    t.string "code", null: false
    t.integer "cost_cents", null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "", null: false
    t.text "description"
    t.datetime "discarded_at"
    t.string "location"
    t.decimal "min_stock", null: false
    t.string "name", null: false
    t.string "nanoid", null: false
    t.integer "price_cents", null: false
    t.decimal "stock_quantity", null: false
    t.string "supplier_id"
    t.datetime "updated_at", null: false
    t.string "warranty"
    t.integer "weight_grams"
    t.index ["aasm_state"], name: "index_products_on_aasm_state"
    t.index ["barcode"], name: "index_products_on_barcode", unique: true
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["code"], name: "index_products_on_code", unique: true
    t.index ["discarded_at"], name: "index_products_on_discarded_at"
    t.index ["nanoid"], name: "index_products_on_nanoid", unique: true
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "rules", id: :string, force: :cascade do |t|
    t.string "action", limit: 32, null: false
    t.datetime "created_at", null: false
    t.boolean "enabled", default: true
    t.string "group_id", null: false
    t.string "nanoid", null: false
    t.string "resource", limit: 64, null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "resource", "action"], name: "index_rules_on_group_resource_action", unique: true
    t.index ["group_id"], name: "index_rules_on_group_id"
    t.index ["nanoid"], name: "index_rules_on_nanoid", unique: true
  end

  create_table "sale_items", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency", default: "", null: false
    t.integer "discount_cents", null: false
    t.string "nanoid", null: false
    t.string "product_id", null: false
    t.decimal "quantity", null: false
    t.string "sale_id", null: false
    t.integer "unit_price_cents", null: false
    t.datetime "updated_at", null: false
    t.index ["nanoid"], name: "index_sale_items_on_nanoid", unique: true
    t.index ["product_id"], name: "index_sale_items_on_product_id"
    t.index ["sale_id"], name: "index_sale_items_on_sale_id"
  end

  create_table "sales", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency", default: "", null: false
    t.string "customer_id"
    t.integer "discount_cents", null: false
    t.integer "installments", null: false
    t.string "nanoid", null: false
    t.text "notes"
    t.string "number", null: false
    t.string "payment_method", null: false
    t.date "sold_at", null: false
    t.integer "total_cents", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["customer_id"], name: "index_sales_on_customer_id"
    t.index ["nanoid"], name: "index_sales_on_nanoid", unique: true
    t.index ["number"], name: "index_sales_on_number", unique: true
    t.index ["sold_at"], name: "index_sales_on_sold_at"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "suppliers", id: :string, force: :cascade do |t|
    t.string "city"
    t.string "cnpj"
    t.string "company_name", null: false
    t.string "contact_name"
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "email"
    t.decimal "lead_time", default: "10.0"
    t.string "nanoid", null: false
    t.text "notes"
    t.decimal "payment_days", default: "30.0"
    t.string "phone"
    t.string "state", limit: 2
    t.string "trading_name"
    t.datetime "updated_at", null: false
    t.index ["cnpj"], name: "index_suppliers_on_cnpj", unique: true, where: "cnpj IS NOT NULL"
    t.index ["discarded_at"], name: "index_suppliers_on_discarded_at"
    t.index ["nanoid"], name: "index_suppliers_on_nanoid", unique: true
  end

  create_table "user_assignments", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "group_id", null: false
    t.string "nanoid", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["group_id"], name: "index_user_assignments_on_group_id"
    t.index ["nanoid"], name: "index_user_assignments_on_nanoid", unique: true
    t.index ["user_id"], name: "index_user_assignments_on_user_id"
  end

  create_table "user_permissions", id: :string, force: :cascade do |t|
    t.string "group_id", null: false
    t.string "nanoid", null: false
    t.string "rules_id", null: false
    t.string "user_assignment_id", null: false
    t.index ["group_id"], name: "index_user_permissions_on_group_id"
    t.index ["nanoid"], name: "index_user_permissions_on_nanoid", unique: true
    t.index ["rules_id"], name: "index_user_permissions_on_rules_id"
    t.index ["user_assignment_id"], name: "index_user_permissions_on_user_assignment_id"
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.datetime "birthday"
    t.string "civil_status", default: ""
    t.text "complement", default: "{}"
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "document", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.string "nanoid", null: false
    t.string "other_contacts", limit: 1024, default: "", null: false
    t.string "phone", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nanoid"], name: "index_users_on_nanoid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :string, force: :cascade do |t|
    t.datetime "created_at"
    t.string "event", null: false
    t.string "item_id", null: false
    t.string "item_type", null: false
    t.string "nanoid"
    t.text "object"
    t.text "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["nanoid"], name: "index_versions_on_nanoid", unique: true
  end

  add_foreign_key "accounts_payable", "suppliers"
  add_foreign_key "accounts_receivable", "customers"
  add_foreign_key "accounts_receivable", "sales"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "movements", "products"
  add_foreign_key "movements", "sales"
  add_foreign_key "movements", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "suppliers"
  add_foreign_key "rules", "groups"
  add_foreign_key "sale_items", "products"
  add_foreign_key "sale_items", "sales"
  add_foreign_key "sales", "customers"
  add_foreign_key "sales", "users"
  add_foreign_key "user_assignments", "groups"
  add_foreign_key "user_assignments", "users"
  add_foreign_key "user_permissions", "groups"
  add_foreign_key "user_permissions", "rules", column: "rules_id"
  add_foreign_key "user_permissions", "user_assignments"
end
