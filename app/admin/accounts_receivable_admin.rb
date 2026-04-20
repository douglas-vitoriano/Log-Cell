Trestle.resource(:accounts_receivable) do
  menu do
    item :accounts_receivable, icon: "fas fa-hand-holding-usd",
                               label: I18n.t("sidebar.receivable"),
                               group: I18n.t("delimiter.financ"),
                               priority: 7
  end

  collection do
    AccountsReceivable.includes(:customer, :sale).order(due_date: :asc)
  end

  table do
    column :document_number, header: "Nº Documento"
    column :customer, header: "Cliente" do | r |
      r.customer&.name || "—"
    end
    column :amount, header: "Valor" do | r |
      r.amount.format
    end
    column :paid, header: "Pago" do | r |
      r.paid.format
    end
    column :balance,         header: "Saldo" do | r |
      Money.new(r.balance_cents, "BRL").format
    end
    column :due_date,        header: "Vencimento", format: :date
    column :aasm_state, header: "Status" do |r|
      state = Enum::FINANCIAL_STATES[r.aasm_state.to_sym]
      status_tag(state[:label], state[:tag]) if state
    end
    actions do |a|
      a.link "✅ Receber", icon: "fas fa-check",
        to: trestle.accounts_receivable_path(a.instance),
        method: :patch,
        data: { confirm: "Confirmar recebimento?" } unless a.instance.paid?
    end
  end

  form modal: true do |rec|
    row do
      col(sm: 4) { text_field  :document_number, label: "Nº Documento" }
      col(sm: 4) { date_field  :due_date,        label: "Vencimento" }
      col(sm: 4) do
        select :aasm_state,
          AccountsReceivable.aasm.states.map { |s| [ s.name.to_s.humanize, s.name ] },
          label: "Status"
      end
    end
    row do
      col(sm: 4) { text_field :amount,      value: rec.amount&.to_f, label: "Valor (R$)" }
      col(sm: 4) { text_field :paid,        value: rec.paid&.to_f,   label: "Pago (R$)" }
      col(sm: 4) do
        select :customer_id,
          Customer.kept.ordered.map { |c| [ c.name, c.id ] },
          include_blank: "Nenhum", label: "Cliente"
      end
    end
    text_area :notes, rows: 2, label: "Observações"
  end

  params do |params|
    params.require(:accounts_receivable).permit(
      :document_number, :due_date, :amount, :paid,
      :aasm_state, :customer_id, :notes
    )
  end
end
