class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers, id: :string, primary_key: :id do |t|
      t.string  :nanoid,   null: false
      t.string  :name,     null: false
      t.string  :cpf_cnpj
      t.string  :phone
      t.string  :whatsapp
      t.string  :email
      t.string  :address
      t.string  :zip_code
      t.string  :city
      t.date    :birthday
      t.text    :notes
      t.datetime :discarded_at
      t.timestamps
    end

    add_index :customers, :cpf_cnpj,    unique: true, where: "cpf_cnpj IS NOT NULL"
    add_index :customers, :discarded_at
    add_index :customers, :nanoid,      unique: true
  end
end
