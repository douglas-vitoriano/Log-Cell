class AccountsReceivable < ApplicationRecord
  self.table_name = "accounts_receivable"

  include Nanoidable
  include AASM

  belongs_to :sale,     optional: true
  belongs_to :customer, optional: true

  monetize :amount_cents, :paid_cents

  validates :document_number, presence: true
  validates :due_date,        presence: true

  aasm column: :aasm_state do
    state :open, initial: true
    state :paid
    state :overdue
    state :cancelled

    event :pay do
      transitions from: [ :open, :overdue ], to: :paid
      after { update!(paid_at: Date.current) }
    end
    event :mark_overdue do; transitions from: :open, to: :overdue; end
    event :cancel       do; transitions from: [ :open, :overdue ], to: :cancelled; end
  end

  def balance_cents
    amount_cents - paid_cents
  end

  def overdue_days
    return 0 if paid? || due_date >= Date.current
    (Date.current - due_date).to_i
  end

  def interest_cents
    return 0 unless overdue?
    (balance_cents * interest_rate * overdue_days / 30).to_i
  end

  scope :overdue_unpaid, -> {
    where(aasm_state: %w[open overdue]).where("due_date < ?", Date.current)
  }
end
