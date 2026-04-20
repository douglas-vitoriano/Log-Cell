class Movement < ApplicationRecord
  include Nanoidable

  belongs_to :product
  belongs_to :user
  belongs_to :sale, optional: true

  monetize :cost_cents

  KINDS = %w[entrada saida ajuste].freeze
  validates :kind,     inclusion: { in: KINDS }
  validates :quantity, presence: true

  scope :entry_types,   -> { where(kind: "entrada") }
  scope :exit_types,    -> { where(kind: "saida") }
  scope :adjustment_types, -> { where(kind: "ajuste") }
end
