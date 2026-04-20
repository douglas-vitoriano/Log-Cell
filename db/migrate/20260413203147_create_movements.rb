class CreateMovements < ActiveRecord::Migration[8.1]
  def change
    create_table :movements, id: :string, primary_key: :id do |t|
      t.string     :nanoid,      null: false
      t.references :product,     null: false, type: :string, foreign_key: true
      t.references :user,        null: false, type: :string, foreign_key: true
      t.references :sale,        null: true,  type: :string, foreign_key: true
      t.string     :kind,        null: false
      t.decimal    :quantity,    null: false
      t.integer    :cost_cents,  null: false
      t.string     :currency,    null: false, default: ""
      t.string     :reason
      t.string     :document_ref
      t.timestamps
    end

    add_index :movements, :kind
    add_index :movements, :nanoid, unique: true
  end
end
