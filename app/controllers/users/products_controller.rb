module Admin
  class ProductsController < ApplicationController
    before_action :authenticate_user!

    def search
      q = params[:q].to_s.strip
      products = Product.kept.where(aasm_state: :ativo).where("name LIKE :q OR code LIKE :q OR barcode LIKE :q", q: "%#{q}%").limit(10)

      render json: products.map { |p|
        {
          id: p.id,
          name: p.name,
          code: p.code,
          barcode: p.barcode,
          price_cents: p.price_cents,
          stock_quantity: p.stock_quantity
        }
      }
    end
  end
end
