class CreateSaleItems < ActiveRecord::Migration[8.1]
  def change
    create_table :sale_items, id: :string, primary_key: :id do |t|
      t.string     :nanoid,           null: false
      t.references :sale,             null: false, type: :string, foreign_key: true
      t.references :product,          null: false, type: :string, foreign_key: true
      t.decimal    :quantity,         null: false
      t.integer    :unit_price_cents, null: false
      t.integer    :discount_cents,   null: false
      t.string     :currency,         null: false, default: ""
      t.timestamps
    end
    add_index :sale_items, :nanoid, unique: true
  end
end
