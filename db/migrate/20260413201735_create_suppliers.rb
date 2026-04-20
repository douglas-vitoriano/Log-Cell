class CreateSuppliers < ActiveRecord::Migration[8.1]
  def change
    create_table :suppliers, id: :string, primary_key: :id do |t|
      t.string  :nanoid,        null: false
      t.string  :company_name,  null: false
      t.string  :trading_name
      t.string  :cnpj
      t.string  :contact_name
      t.string  :phone
      t.string  :email
      t.string  :city
      t.string  :state,         limit: 2
      t.decimal :payment_days,  default: 30
      t.decimal :lead_time,     default: 10
      t.text    :notes
      t.datetime :discarded_at
      t.timestamps
    end

    add_index :suppliers, :cnpj,         unique: true, where: "cnpj IS NOT NULL"
    add_index :suppliers, :discarded_at
    add_index :suppliers, :nanoid,       unique: true
  end
end
