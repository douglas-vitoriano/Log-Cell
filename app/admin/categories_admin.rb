Trestle.resource(:categories) do
  menu do
    item :categories, icon: "fas fa-tags",
                      label: I18n.t("sidebar.categories"),
                      group: I18n.t("delimiter.cadastros"),
                      priority: 4
  end

  collection { Category.order(:name) }

  table do
    column :icon,   header: false do |c|
      content_tag(:span, c.icon, style: "font-size: 18px")
    end
    column :name,   link: true
    column :active do |c|
      c.active? ? "✅ Ativo" : "⛔ Inativo"
    end
    column :products_count, ->(c) { c.products.kept.count }
    actions
  end

  form modal: true do |category|
    row do
      col(sm: 2) { text_field :icon }
      col(sm: 8) { text_field :name }
      col(sm: 2) { check_box  :active }
    end
    text_area :description, rows: 2
  end

  params do |params|
    params.require(:category).permit(:name, :icon, :active, :description)
  end
end
