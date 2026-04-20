Trestle.resource(:sales) do
  menu do
    item :sales, icon: "fa fa-shopping-cart", label: I18n.t("sidebar.sales")
  end

  search do |query|
    if query.present?
      collection
        .joins("LEFT JOIN customers ON customers.id = sales.customer_id")
        .joins("LEFT JOIN sale_items ON sale_items.sale_id = sales.id")
        .joins("LEFT JOIN products ON products.id = sale_items.product_id")
        .where(
          "sales.number ILIKE :q OR customers.name ILIKE :q OR products.name ILIKE :q OR products.code ILIKE :q",
          q: "%#{query}%"
        )
        .distinct
    else
      collection
    end
  end

  collection do
    Sale.includes(:customer, :user, :sale_items).order(sold_at: :desc)
  end

  build_instance do |attrs|
    Sale.new(attrs.merge(user: current_user))
  end

  update_instance do |instance, attrs|
    instance.assign_attributes(attrs)
  end

  table do
    column :number
    column :sold_at do |sale|
      sale.sold_at&.strftime("%d/%m/%Y")
    end
    column :customer,      ->(s) { s.customer&.name || "Balcão" }
    column :user,          ->(s) { s.user&.name }
    column :items,         ->(s) { "#{s.sale_items.count} item(s)" }
    column :total,         ->(s) { Money.new(s.net_total_cents, "BRL").format }
    column :payment_method
    actions
  end

  form do |sale|
    render "admin/sales/items_form", sale: sale

    row do
      col(sm: 4) { date_field :sold_at }
      col(sm: 4) { select :customer_id, Customer.kept.ordered.map { |c| [ c.name, c.id ] }, include_blank: "Balcão" }
      col(sm: 4) { select :payment_method, Enum.payment_methods_options }
    end
    row do
      col(sm: 4) { number_field :installments }
      col(sm: 4) { text_field   :discount, value: sale.discount&.to_f }
    end
    row do
      col(sm: 12) { text_area :notes, rows: 1 }
    end
  end

  params do |params|
    params.require(:sale).permit(
      :sold_at, :customer_id, :payment_method,
      :installments, :discount, :notes,
      sale_items_attributes: [ :id, :product_id, :quantity,
                              :unit_price_cents, :discount_cents, :_destroy ]
    )
  end
end
