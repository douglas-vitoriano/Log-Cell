module ApplicationHelper
  def money(cents, currency = "BRL")
    Money.new(cents.to_i, currency).format
  end

  def aasm_badge(state)
    colors = {
      "active"      => "success",
      "inactive"    => "secondary",
      "discontinued"=> "danger",
      "pending"     => "warning",
      "completed"   => "success",
      "cancelled"   => "danger",
      "open"        => "info",
      "paid"        => "success",
      "overdue"     => "danger"
    }
    label = {
      "active"       => "Ativo",
      "inactive"     => "Inativo",
      "discontinued" => "Descontinuado",
      "pending"      => "Pendente",
      "completed"    => "Concluída",
      "cancelled"    => "Cancelada",
      "open"         => "Aberto",
      "paid"         => "Pago",
      "overdue"      => "Vencido"
    }
    color = colors.fetch(state.to_s, "secondary")
    text  = label.fetch(state.to_s, state.to_s.humanize)
    content_tag(:span, text, class: "badge badge-#{color}")
  end
end
