module Enum
  # ── Produto ─────────────────────────────────────────
  PRODUCT_STATES = {
    ativo:         { label: "Ativo",          tag: :success },
    inativo:       { label: "Inativo",        tag: :warning },
    descontinuado: { label: "Descontinuado",  tag: :danger  }
  }.freeze

  STOCK_STATUS = {
    ok:       { label: "Em Dia",   icon: "✅", tag: :success },
    low:      { label: "Baixo",    icon: "⚠️", tag: :warning },
    critical: { label: "Crítico",  icon: "❌", tag: :danger  }
  }.freeze

  # ── Venda ────────────────────────────────────────────
  SALE_STATES = {
    pending:   { label: "Pendente",   tag: :warning },
    completed: { label: "Concluída",  tag: :success },
    cancelled: { label: "Cancelada",  tag: :danger  }
  }.freeze

  PAYMENT_METHODS = {
    dinheiro: { label: "Dinheiro", icon: "💵" },
    pix:      { label: "Pix",      icon: "📲" },
    debito:   { label: "Débito",   icon: "💳" },
    credito:  { label: "Crédito",  icon: "💳" }
  }.freeze

  # ── Financeiro ───────────────────────────────────────
  FINANCIAL_STATES = {
    open:      { label: "Aberto",     tag: :info    },
    paid:      { label: "Pago",       tag: :success },
    overdue:   { label: "Vencido",    tag: :danger  },
    cancelled: { label: "Cancelado",  tag: :secondary }
  }.freeze

  PAYABLE_CATEGORIES = {
    merchandise: { label: "Mercadoria"   },
    rent:        { label: "Aluguel"      },
    salaries:    { label: "Salários"     },
    energy:      { label: "Energia"      },
    internet:    { label: "Internet"     },
    marketing:   { label: "Marketing"    },
    accounting:  { label: "Contabilidade" },
    other:       { label: "Outros"       }
  }.freeze

  # ── Movimentação ─────────────────────────────────────
  MOVEMENT_KINDS = {
    entrada: { label: "Entrada",  icon: "✅" },
    saida:   { label: "Saída",    icon: "📤" },
    ajuste:  { label: "Ajuste",   icon: "🔄" }
  }.freeze

  # ── Grupos de acesso ─────────────────────────────────
  GROUP_CODES = {
    sysadmin: { label: "Administrador" },
    partner:  { label: "Sócio"         },
    manager:  { label: "Gerente"       },
    operator: { label: "Operador"      }
  }.freeze

  def self.product_states_options
    PRODUCT_STATES.map { |k, v| [ v[:label], k ] }
  end

  def self.payment_methods_options
    PAYMENT_METHODS.map { |k, v| [ v[:label], k ] }
  end

  def self.payable_categories_options
    PAYABLE_CATEGORIES.map { |k, v| [ v[:label], k ] }
  end

  def self.financial_states_options
    FINANCIAL_STATES.map { |k, v| [ v[:label], k ] }
  end

  def self.movement_kinds_options
    MOVEMENT_KINDS.map { |k, v| [ v[:label], k ] }
  end

  def self.label_for(const, key)
    const.dig(key.to_sym, :label) || key.to_s.humanize
  end
end
