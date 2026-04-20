class CreateAccountsPayable < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts_payable, id: :string, primary_key: :id do |t|
      t.string     :nanoid,          null: false
      t.references :supplier,        null: true, type: :string, foreign_key: true
      t.string     :document_number, null: false
      t.string     :description,     null: false
      t.string     :category,        null: false, default: ""
      t.integer    :amount_cents,    null: false
      t.integer    :paid_cents,      null: false
      t.string     :currency,        null: false, default: ""
      t.date       :due_date,        null: false
      t.date       :paid_at
      t.string     :aasm_state,      null: false, default: ""
      t.text       :notes
      t.timestamps
    end

    add_index :accounts_payable, :due_date
    add_index :accounts_payable, :nanoid,  unique: true
  end
end
