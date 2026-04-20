class CreateGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :groups, id: :string, primary_key: :id do |t|
      t.string :nanoid, null: false
      t.string :code, limit: 32
      t.string :name, limit: 128
      t.boolean :enabled, default: true
      t.timestamps
    end

    add_index :groups, :nanoid, unique: true
  end
end
