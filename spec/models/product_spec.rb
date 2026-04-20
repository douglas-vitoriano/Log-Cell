require "rails_helper"

RSpec.describe Product, type: :model do
  let(:category) { Category.create!(name: "Test", icon: "📦") }

  let(:valid_product) do
    Product.new(
      name: "Produto Teste",
      code: "PT001",
      category: category,
      price_cents: 1000,
      cost_cents: 500,
      stock_quantity: 10,
      min_stock: 5
    )
  end

  describe "validações" do
    it "é válido com atributos válidos" do
      expect(valid_product).to be_valid
    end

    it "é inválido sem nome" do
      valid_product.name = nil
      expect(valid_product).not_to be_valid
    end

    # CORREÇÃO: Como o modelo gera o código automaticamente,
    # testamos se ele preenche o campo em vez de esperar um erro.
    it "gera um código automaticamente se for enviado em branco" do
      valid_product.code = nil
      valid_product.valid?
      expect(valid_product.code).to be_present
      expect(valid_product.code).to start_with("P")
    end

    it "é inválido se o código for duplicado" do
      valid_product.save!
      duplicate_product = valid_product.dup
      expect(duplicate_product).not_to be_valid
    end

    it "é inválido com preço zero" do
      valid_product.price_cents = 0
      expect(valid_product).not_to be_valid
    end

    it "normaliza barcode vazio para nil" do
      valid_product.barcode = ""
      valid_product.valid?
      expect(valid_product.barcode).to be_nil
    end
  end

  describe "stock_status" do
    it "retorna :critical quando estoque é zero" do
      valid_product.stock_quantity = 0
      expect(valid_product.stock_status).to eq(:critical)
    end

    it "retorna :low quando estoque está abaixo do mínimo" do
      valid_product.stock_quantity = 3
      valid_product.min_stock = 5
      expect(valid_product.stock_status).to eq(:low)
    end

    it "retorna :ok quando estoque está adequado" do
      valid_product.stock_quantity = 10
      valid_product.min_stock = 5
      expect(valid_product.stock_status).to eq(:ok)
    end
  end

  describe "margin_percent" do
    it "calcula a margem corretamente" do
      valid_product.price_cents = 1000
      valid_product.cost_cents  = 600
      expect(valid_product.margin_percent).to eq(40.0)
    end

    it "retorna 0 se preço for zero" do
      valid_product.price_cents = 0
      expect(valid_product.margin_percent).to eq(0)
    end
  end

  describe "AASM states" do
    before { valid_product.save! }

    it "começa como ativo" do
      expect(valid_product.aasm_state).to eq("ativo")
    end

    it "pode ser desativado" do
      valid_product.desativar!
      expect(valid_product.aasm_state).to eq("inativo")
    end

    it "pode ser reativado" do
      valid_product.desativar!
      valid_product.ativar!
      expect(valid_product.aasm_state).to eq("ativo")
    end
  end
end
