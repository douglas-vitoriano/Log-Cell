Trestle.resource(:customers) do
  menu do
    item :customers, icon: "fa fa-users",
                    label: I18n.t("sidebar.customers"),
                    group: I18n.t("delimiter.cadastros"),
                    priority: 5
  end

  search do |query|
    query ? collection.where(
      "name ILIKE :q OR cpf_cnpj ILIKE :q OR phone ILIKE :q",
      q: "%#{query}%"
    ) : collection
  end

  collection do
    Customer.kept.order(:name)
  end

  table do
    column :name
    column :cpf_cnpj
    column :phone
    column :city
    column :created_at, format: :date
    actions
  end

  form modal: true do |customer|
    row do
      col(sm: 8) { text_field :name }
      col(sm: 4) { text_field :cpf_cnpj, label: "CPF / CNPJ" }
    end
    row do
      col(sm: 4) { text_field :phone }
      col(sm: 4) { text_field :whatsapp }
      col(sm: 4) { text_field :email }
    end
    row do
      col(sm: 8) { text_field :address }
      col(sm: 4) { text_field :zip_code, label: "CEP" }
    end
    row do
      col(sm: 6) { text_field :city }
      col(sm: 6) { date_field :birthday }
    end
    text_area :notes, rows: 2
  end

  params do |params|
    params.require(:customer).permit(
      :name, :cpf_cnpj, :phone, :whatsapp, :email,
      :address, :city, :zip_code, :birthday, :notes
    )
  end
end
