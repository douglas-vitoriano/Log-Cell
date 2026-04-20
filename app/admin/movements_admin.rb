Trestle.resource(:movements, readonly: true) do
  menu do
    item :movements, icon: "fa fa-boxes",
                     label: I18n.t("sidebar.movements"),
                     group: I18n.t("delimiter.operation"),
                     priority: 2
  end

  collection do
    Movement.includes(:product, :user, :sale).order(created_at: :desc)
  end

  # Busca compatível com PostgreSQL e SQLite
  search do |query|
    if query.present?
      collection
        .joins(:product, :user)
        .where(
          "products.name LIKE :q OR movements.kind LIKE :q OR movements.reason LIKE :q",
          q: "%#{query}%"
        )
    else
      collection
    end
  end

  table do
    column :created_at, header: "Data/Hora", format: :datetime
    column :kind, header: "Tipo" do |m|
      status = Enum::MOVEMENT_KINDS[m.kind.to_sym]
      status ? "#{status[:icon]} #{status[:label]}" : m.kind
    end
    column :product,      header: "Produto" do |m|
        m.product&.name || "—"
    end
    column :quantity,     header: "Quantidade"
    column :cost,         header: "Custo"   do |m|
      m.cost.format
    end
    column :reason,       header: "Motivo"
    column :document_ref, header: "Ref. Doc."
    column :user,         header: "Usuário" do |m|
      m.user&.name || "—"
    end
  end
end
