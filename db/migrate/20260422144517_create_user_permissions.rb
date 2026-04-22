class CreateUserPermissions < ActiveRecord::Migration[8.1]
  def change
    create_table :user_permissions, id: :string, primary_key: :id do |t|
      t.string :nanoid, null: false
      t.references :group, null: false, type: :string, foreign_key: true
      t.references :rules, null: false, type: :string, foreign_key: true
      t.references :user_assignment, null: false, type: :string, foreign_key: true
    end

    add_index :user_permissions, :nanoid, unique: true
  end
end
