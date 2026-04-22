class CreateRules < ActiveRecord::Migration[8.1]
  def change
    create_table :rules, id: :string, primary_key: :id do |t|
      t.string :nanoid, null: false
      t.string  :group_id,    null: false
      t.string  :resource,    null: false, limit: 64
      t.string  :action,      null: false, limit: 32
      t.boolean :enabled,     default: true

      t.timestamps
    end

    add_index :rules, :nanoid,              unique: true
    add_index :rules, :group_id
    add_index :rules, [ :group_id, :resource, :action ], unique: true, name: "index_rules_on_group_resource_action"

    add_foreign_key :rules, :groups
  end
end
