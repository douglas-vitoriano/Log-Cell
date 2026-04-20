class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales, id: :string, primary_key: :id do |t|
      t.references :customer, null: true,  type: :string, foreign_key: true
      t.references :user,     null: false, type: :string, foreign_key: true

      t.string     :nanoid,         null: false
      t.string     :number,         null: false
      t.integer    :total_cents,    null: false
      t.integer    :discount_cents, null: false
      t.string     :currency,       null: false, default: ""
      t.string     :payment_method, null: false
      t.integer    :installments,   null: false
      t.date       :sold_at,        null: false
      t.text       :notes
      t.timestamps
    end

    add_index :sales, :number,    unique: true
    add_index :sales, :sold_at
    add_index :sales, :nanoid,    unique: true
  end
end
