class Sale < ApplicationRecord
  include Nanoidable
  include AASM

  belongs_to :customer, optional: true
  belongs_to :user, optional: true
  has_many :sale_items, dependent: :destroy
  has_many :products, through: :sale_items
  has_many :accounts_receivable

  accepts_nested_attributes_for :sale_items, allow_destroy: true

  monetize :total_cents, :discount_cents

  PAYMENT_METHODS = Enum::PAYMENT_METHODS.keys.map(&:to_s).freeze

  validates :number,         presence: true, uniqueness: true
  validates :payment_method, inclusion: { in: PAYMENT_METHODS }
  validates :sold_at,        presence: true

  before_validation :generate_number, on: :create

  def net_total_cents
    total_cents - discount_cents
  end

  def margin_percent
    return 0 if total_cents.zero?
    cost = sale_items.sum { |i| i.product.cost_cents * i.quantity }
    ((total_cents - cost).to_f / total_cents * 100).round(1)
  end

  scope :this_month, -> { where(sold_at: Time.current.beginning_of_month..) }
  scope :by_period,  ->(from, to) { where(sold_at: from..to) }

  private

  def generate_number
    self.number ||= "V#{Time.current.strftime('%Y%m%d')}#{SecureRandom.hex(2).upcase}"
  end

  def update_stock!
    sale_items.each do |item|
      item.product.decrement!(:stock_quantity, item.quantity)
      Movement.create!(
        product: item.product, user: user, sale: self,
        kind: "saida", quantity: item.quantity,
        cost_cents: item.unit_price_cents,
        reason: "Venda #{number}"
      )
    end
  end

  def restore_stock!
    sale_items.each do |item|
      item.product.increment!(:stock_quantity, item.quantity)
      Movement.create!(
        product: item.product, user: user, sale: self,
        kind: "ajuste", quantity: item.quantity,
        cost_cents: item.unit_price_cents,
        reason: "Cancelamento #{number}"
      )
    end
  end
end
