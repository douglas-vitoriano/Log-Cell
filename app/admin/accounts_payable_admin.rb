Trestle.resource(:accounts_payable) do
  menu do
    item :accounts_payable, icon: "fas fa-file-invoice-dollar",
                            label: I18n.t("sidebar.payable"),
                            group: I18n.t("delimiter.financ"),
                            priority: 7
  end

  collection do
    AccountsPayable.includes(:supplier).order(due_date: :asc)
  end

  table do
    column :document_number
    column :description
    column :supplier,  ->(p) { p.supplier&.company_name || "—" }
    column :category
    column :amount,    ->(p) { p.amount.format }
    column :due_date,  format: :date
    column :aasm_state
    actions
  end

  form modal: true do |pay|
    row do
      col(sm: 4) { text_field :document_number }
      col(sm: 8) { text_field :description }
    end
    row do
      col(sm: 4) { select :category, Enum.payable_categories_options }
      col(sm: 4) { select :supplier_id, Supplier.kept.ordered.map { |s| [ s.company_name, s.id ] }, include_blank: "Nenhum" }
      col(sm: 4) { date_field :due_date }
    end
    row do
      col(sm: 4) { text_field :amount, value: pay.amount&.to_f }
      col(sm: 4) { text_field :paid,   value: pay.paid&.to_f }
    end
    text_area :notes, rows: 2
  end

  params do |params|
    params.require(:accounts_payable).permit(
      :document_number, :description, :category,
      :amount, :paid, :due_date, :supplier_id, :notes
    )
  end
end
