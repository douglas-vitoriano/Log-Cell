class AccountsPayable < ApplicationRecord
  self.table_name = "accounts_payable"

  include Nanoidable
  include AASM

  belongs_to :supplier, optional: true

  monetize :amount_cents, :paid_cents

  CATEGORIES = %w[merchandise rent salaries energy internet marketing accounting other].freeze

  validates :document_number, presence: true
  validates :description,     presence: true
  validates :due_date,        presence: true
  validates :category,        inclusion: { in: CATEGORIES }

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

  scope :overdue_unpaid, -> {
    where(aasm_state: %w[open overdue]).where("due_date < ?", Date.current)
  }
end
