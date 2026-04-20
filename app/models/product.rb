class Product < ApplicationRecord
  include Nanoidable
  include Discard::Model
  include AASM

  belongs_to :category
  belongs_to :supplier, optional: true
  has_many :sale_items
  has_many :movements
  has_one_attached :image

  monetize :cost_cents,  :price_cents

  validates :code,        presence: true, uniqueness: true
  validates :name,        presence: true
  validates :price_cents, numericality: { greater_than: 0 }
  validates :cost_cents,  numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  aasm column: :aasm_state do
    state :ativo, initial: true
    state :inativo
    state :descontinuado

    event :desativar     do; transitions from: :ativo,               to: :inativo;       end
    event :ativar        do; transitions from: :inativo,             to: :ativo;         end
    event :descontinuar  do; transitions from: [ :ativo, :inativo ], to: :descontinuado; end
  end

  def margin_percent
    return 0 if price_cents.zero?
    ((price_cents - cost_cents).to_f / price_cents * 100).round(1)
  end

  def stock_status
    if stock_quantity <= 0        then :critical
    elsif stock_quantity < min_stock then :low
    else :ok
    end
  end

  def state_label
    Enum::PRODUCT_STATES[aasm_state.to_sym]
  end

  def barcode_image
    return nil if barcode.blank?
    blob = Barby::Code128B.new(barcode).to_png(height: 40, margin: 4)
    Base64.strict_encode64(blob)
  end

  def qrcode_svg
    RQRCode::QRCode.new(
      "#{code}|#{name}|#{price_cents}",
      level: :m
    ).as_svg(offset: 0, color: "000", module_size: 4, standalone: true)
  end

  scope :ativo,         -> { kept.where(aasm_state: :ativo) }
  scope :baixo_estoque, -> { kept.where("stock_quantity < min_stock AND stock_quantity > 0") }
  scope :sem_estoque,   -> { kept.where("stock_quantity <= 0") }
  scope :by_category,   ->(cat) { where(category: cat) }

  before_validation :normalize_barcode
  before_validation :generate_code, on: :create, if: -> { code.blank? }

  private

  def generate_code
    return unless category
    self.code = "P#{category.name[0].upcase}#{Nanoid.generate(size: 8)}"
  end

  def normalize_barcode
    self.barcode = nil if barcode.blank?
  end
end
