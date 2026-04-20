Trestle.resource(:suppliers) do
  menu do
    item :suppliers, icon: "fas fa-tags",
                      label: I18n.t("sidebar.suppliers"),
                      group: I18n.t("delimiter.cadastros"),
                      priority: 6
  end

  search do |query|
    query ? collection.where(
      "company_name ILIKE :q OR cnpj ILIKE :q",
      q: "%#{query}%"
    ) : collection
  end

  collection { Supplier.kept.order(:company_name) }

  table do
    column :company_name
    column :cnpj
    column :contact_name
    column :phone
    column :city
    column :payment_days
    column :lead_time
    actions
  end

  form modal: true do |supplier|
    row do
      col(sm: 8) { text_field :company_name }
      col(sm: 4) { text_field :cnpj, label: "CNPJ" }
    end
    row do
      col(sm: 6) { text_field :contact_name }
      col(sm: 3) { text_field :phone }
      col(sm: 3) { text_field :email }
    end
    row do
      col(sm: 4) { text_field :city }
      col(sm: 2) { text_field :state, label: "UF" }
      col(sm: 3) { number_field :payment_days }
      col(sm: 3) { number_field :lead_time }
    end
    text_area :notes, rows: 2
  end

  params do |params|
    params.require(:supplier).permit(
      :company_name, :trading_name, :cnpj, :contact_name,
      :phone, :email, :city, :state, :payment_days, :lead_time, :notes
    )
  end
end
