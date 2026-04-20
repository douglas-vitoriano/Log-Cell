require "rails_helper"

RSpec.describe SaleItem, type: :model do
  let(:category) { Category.create!(name: "Cat", icon: "📦") }
  let(:product) do
    Product.create!(
      name: "Produto", code: "P001", category: category,
      price_cents: 2000, cost_cents: 1000, stock_quantity: 10, min_stock: 5
    )
  end
  let(:user) { User.create!(name: "U", email: "u@u.com", password: "123456") }
  let(:sale) do
    Sale.create!(
      user: user, sold_at: Date.current,
      payment_method: "dinheiro", total_cents: 0,
      discount_cents: 0, installments: 1
    )
  end

  let(:item) do
    SaleItem.new(
      sale: sale, product: product,
      quantity: 2, unit_price_cents: 2000, discount_cents: 0
    )
  end

  it "é válido" do
    expect(item).to be_valid
  end

  it "calcula total_cents corretamente" do
    expect(item.total_cents).to eq(4000)
  end

  it "desconta corretamente" do
    item.discount_cents = 500
    expect(item.total_cents).to eq(3500)
  end

  it "é inválido com quantidade zero" do
    item.quantity = 0
    expect(item).not_to be_valid
  end
end
