class Customer < ApplicationRecord
  include Nanoidable
  include Discard::Model

  has_many :sales
  has_many :accounts_receivable

  validates :name, presence: true

  def total_purchases
    sales.completed.sum(:total_cents) / 100.0
  end

  scope :ordered, -> { order(:name) }
end
