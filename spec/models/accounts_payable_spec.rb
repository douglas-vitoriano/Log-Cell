require "rails_helper"

RSpec.describe AccountsPayable, type: :model do
  let(:valid_payable) do
    AccountsPayable.new(
      document_number: "NF-001",
      description: "Compra de mercadoria",
      category: "merchandise",
      due_date: Date.current + 30,
      amount_cents: 50000,
      paid_cents: 0
    )
  end

  it "é válido" do
    expect(valid_payable).to be_valid
  end

  it "é inválido sem documento" do
    valid_payable.document_number = nil
    expect(valid_payable).not_to be_valid
  end

  it "é inválido com categoria inválida" do
    valid_payable.category = "invalida"
    expect(valid_payable).not_to be_valid
  end

  it "calcula saldo corretamente" do
    valid_payable.amount_cents = 1000
    valid_payable.paid_cents   = 300
    expect(valid_payable.balance_cents).to eq(700)
  end

  describe "AASM" do
    before { valid_payable.save! }

    it "começa como open" do
      expect(valid_payable.aasm_state).to eq("open")
    end

    it "pode ser pago" do
      valid_payable.pay!
      expect(valid_payable.aasm_state).to eq("paid")
      expect(valid_payable.paid_at).to eq(Date.current)
    end
  end
end
