class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories, id: :string, primary_key: :id do |t|
      t.string :nanoid, null: false

      t.string :name,        null: false
      t.text :description
      t.string :icon,        default: ""
      t.boolean :active,     null: false, default: true
      t.datetime :discarded_at
      t.timestamps
    end

    add_index :categories, :discarded_at
    add_index :categories, :name, unique: true
    add_index :categories, :nanoid, unique: true
  end
end
