class CreateUserAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :user_assignments, id: :string, primary_key: :id do |t|
      t.string :nanoid, null: false
      t.references :user, null: false, type: :string, foreign_key: true
      t.references :group, null: false, type: :string, foreign_key: true
      t.timestamps
    end

    add_index :user_assignments, :nanoid, unique: true
  end
end
