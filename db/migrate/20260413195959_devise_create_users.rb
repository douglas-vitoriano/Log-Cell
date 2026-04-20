class DeviseCreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :string, primary_key: :id do |t|
      t.string   :nanoid,         null: false
      t.string   :name,           null: false
      t.string   :phone,          null: false, default: ""
      t.string   :document,       null: false, default: ""
      t.string   :civil_status,   default: ""
      t.datetime :birthday
      t.string   :other_contacts, limit: 1024, default: "", null: false
      t.text     :complement,     default: "{}"
      t.string   :email,              null: false, default: ""
      t.string   :encrypted_password, null: false, default: ""
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.datetime :discarded_at
      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :nanoid,               unique: true
    add_index :users, :discarded_at
    add_index :users, :reset_password_token, unique: true
  end
end
