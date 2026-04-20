class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products, id: :string, primary_key: :id do |t|
      t.string   :nanoid,         null: false
      t.string   :code,           null: false
      t.string   :name,           null: false
      t.text     :description
      t.references :category,     null: false, type: :string, foreign_key: true
      t.references :supplier,     null: true,  type: :string, foreign_key: true
      t.string   :brand
      t.integer  :cost_cents,     null: false
      t.integer  :price_cents,    null: false
      t.string   :currency,       null: false, default: ""
      t.decimal  :stock_quantity, null: false
      t.decimal  :min_stock,      null: false
      t.integer  :weight_grams
      t.string   :warranty
      t.string   :barcode
      t.string   :location
      t.string   :aasm_state,     null: false, default: ""
      t.datetime :discarded_at
      t.timestamps
    end
    add_index :products, :code,        unique: true
    add_index :products, :aasm_state
    add_index :products, :discarded_at
    add_index :products, :nanoid,      unique: true
    add_index :products, :barcode,     unique: true
  end
end
