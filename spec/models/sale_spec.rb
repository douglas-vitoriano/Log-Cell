require "rails_helper"

RSpec.describe Sale, type: :model do
  let(:user) { User.create!(name: "Vendedor", email: "v@test.com", password: "123456") }

  let(:valid_sale) do
    Sale.new(
      user: user,
      sold_at: Date.current,
      payment_method: "dinheiro",
      total_cents: 1000,
      discount_cents: 0,
      installments: 1
    )
  end

  describe "validações" do
    it "é válido com atributos válidos" do
      expect(valid_sale).to be_valid
    end

    it "é inválido sem data de venda" do
      valid_sale.sold_at = nil
      expect(valid_sale).not_to be_valid
    end

    it "é inválido com método de pagamento inválido" do
      valid_sale.payment_method = "boleto"
      expect(valid_sale).not_to be_valid
    end

    it "aceita todos os métodos de pagamento válidos" do
      Sale::PAYMENT_METHODS.each do |method|
        valid_sale.payment_method = method
        valid_sale.valid?
        expect(valid_sale.errors[:payment_method]).to be_empty
      end
    end
  end

  describe "gera número automaticamente" do
    it "cria um número no formato correto" do
      valid_sale.save!
      expect(valid_sale.number).to match(/^V\d{8}[A-Z0-9]{4}$/)
    end
  end

  describe "net_total_cents" do
    it "subtrai o desconto do total" do
      valid_sale.total_cents    = 1000
      valid_sale.discount_cents = 100
      expect(valid_sale.net_total_cents).to eq(900)
    end
  end
end
