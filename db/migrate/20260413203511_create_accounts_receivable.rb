class CreateAccountsReceivable < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts_receivable, id: :string, primary_key: :id do |t|
      t.string     :nanoid,          null: false
      t.references :sale,            null: true, type: :string, foreign_key: true
      t.references :customer,        null: true, type: :string, foreign_key: true
      t.string     :document_number, null: false
      t.integer    :amount_cents,    null: false
      t.integer    :paid_cents,      null: false
      t.string     :currency,        null: false, default: ""
      t.date       :due_date,        null: false
      t.date       :paid_at
      t.string     :aasm_state,      null: false, default: ""
      t.decimal    :interest_rate,   precision: 5, scale: 4
      t.text       :notes
      t.timestamps
    end

    add_index :accounts_receivable, :due_date
    add_index :accounts_receivable, :nanoid, unique: true
  end
end
