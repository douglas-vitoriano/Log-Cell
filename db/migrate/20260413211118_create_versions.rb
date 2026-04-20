class CreateVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :versions, id: :string, primary_key: :id do |t|
      t.string   :nanoid
      t.string   :item_type,      null: false
      t.string   :item_id,        null: false
      t.string   :event,          null: false
      t.string   :whodunnit
      t.text     :object
      t.text     :object_changes
      t.datetime :created_at
    end
    add_index :versions, :nanoid, unique: true
    add_index :versions, [ :item_type, :item_id ]
  end
end
