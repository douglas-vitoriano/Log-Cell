class SaleItem < ApplicationRecord
  include Nanoidable

  belongs_to :sale
  belongs_to :product

  monetize :unit_price_cents, :discount_cents

  validates :quantity,          numericality: { greater_than: 0 }
  validates :unit_price_cents,  numericality: { greater_than: 0 }

  def total_cents
    (unit_price_cents * quantity) - discount_cents
  end

  def subtotal
    Money.new(total_cents, currency)
  end
end
