class Supplier < ApplicationRecord
  include Nanoidable
  include Discard::Model

  has_many :products
  has_many :accounts_payable

  validates :company_name, presence: true

  scope :ordered, -> { order(:company_name) }
end
