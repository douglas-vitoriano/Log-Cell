require "rails_helper"

RSpec.describe Enum do
  describe "PRODUCT_STATES" do
    it "tem labels para todos os estados" do
      [ :ativo, :inativo, :descontinuado ].each do |state|
        expect(Enum::PRODUCT_STATES[state]).to include(:label, :tag)
      end
    end
  end

  describe "PAYMENT_METHODS" do
    it "inclui todos os métodos aceitos pelo model" do
      Sale::PAYMENT_METHODS.each do |method|
        expect(Enum::PAYMENT_METHODS.keys.map(&:to_s)).to include(method)
      end
    end
  end

  describe ".label_for" do
    it "retorna o label correto" do
      expect(Enum.label_for(Enum::SALE_STATES, :pending)).to eq("Pendente")
    end

    it "retorna humanize quando chave não existe" do
      expect(Enum.label_for(Enum::SALE_STATES, :unknown)).to eq("Unknown")
    end
  end

  describe ".product_states_options" do
    it "retorna array de opções para select" do
      opts = Enum.product_states_options
      expect(opts).to be_an(Array)
      expect(opts.first).to eq([ "Ativo", :ativo ])
    end
  end
end
