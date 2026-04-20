class HomeController < ApplicationController
  def index
    @categories = Category.active.ordered

    all_active_products = Product.kept.ativo.includes(:category).order(:name)

    diverse_products = all_active_products.group_by(&:category_id).map { |_, prods| prods.first }

    remaining_slots = 25 - diverse_products.size

    if remaining_slots > 0
      other_products = all_active_products.reject { |p| diverse_products.include?(p) }
      @products = diverse_products + other_products.first(remaining_slots)
    else
      @products = diverse_products.first(25)
    end
  end
end
