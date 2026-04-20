Trestle.resource(:products) do
  menu do
    item :products, icon: "fa fa-box",
                    label: I18n.t("sidebar.products"),
                    group: I18n.t("delimiter.operation"),
                    priority: 3
  end

  search do |query|
    query ? collection.where(
      "name ILIKE :q OR code ILIKE :q OR barcode ILIKE :q",
      q: "%#{query}%"
    ) : collection
  end

  collection do
    Product.kept.includes(:category, :supplier).order(:name)
  end

  scope :todos, -> { Product.joins(:image_attachment) }, default: true
  scope :sem_imagem, -> { Product.where.missing(:image_attachment) }
  scope :estoque_ok, -> { Product.where("stock_quantity >= min_stock AND stock_quantity > 0") }, label: "Estoque em Dia"
  scope :estoque_baixo, -> { Product.where("stock_quantity < min_stock AND stock_quantity > 0") }, label: "Estoque Baixo"
  scope :estoque_critico, -> { Product.where("stock_quantity <= 0") }, label: "Estoque Crítico"

  table do
    column :image, header: false, align: :center do |p|
      if p.image.attached?
        tag.img(
          src: Rails.application.routes.url_helpers.rails_blob_path(p.image, only_path: true),
          style: "height:40px; width:40px; object-fit:cover; border-radius:6px;"
        )
      else
        content_tag(:span, p.category&.icon || "📦", style: "font-size:24px;")
      end
    end
    column :code, header: "Cód."
    column :name, header: "Produto"
    column :category, header: "Categoria"
    column :price, header: "Venda", align: :center do |p|
      p.price.format
    end

    column :stock_quantity, header: "Qtd", align: :center

    column :stock_status, header: "Estoque", align: :center do |p|
      status = Enum::STOCK_STATUS[p.stock_status]
      status_tag(status[:label], status[:tag]) if status
    end

    column :aasm_state, header: "Status" do |p|
      state = Enum::PRODUCT_STATES[p.aasm_state.to_sym]
      status_tag(state[:label], state[:tag]) if state
    end

    actions
  end

  form modal: true do |product|
    tab :Produto do
      row do
        col(sm: 12) { file_field :image, label: "Imagem do produto", accept: "image/*" }
      end
      row do
        col(sm: 4) { text_field :code }
        col(sm: 8) { text_field :name }
      end
      row do
        col(sm: 6) { select :category_id, Category.active.ordered.map { |c| [ c.name, c.id ] } }
        col(sm: 6) { select :supplier_id, Supplier.kept.ordered.map { |s| [ s.company_name, s.id ] }, include_blank: "Nenhum" }
      end
      row do
        col(sm: 4) { text_field   :price, value: product.price&.to_f }
        col(sm: 4) { text_field   :cost,  value: product.cost&.to_f }
        col(sm: 4) { select       :aasm_state, Enum.product_states_options, label: "Status" }
      end
      row do
        col(sm: 3) { number_field :stock_quantity }
        col(sm: 3) { number_field :min_stock }
        col(sm: 3) { text_field   :barcode }
        col(sm: 3) { text_field   :brand }
      end
      row do
        col(sm: 12) { text_area :description, rows: 3 }
      end
    end

    tab :Detalhes do
      row do
        col(sm: 4) { text_field :warranty, label: "Garantia" }
        col(sm: 4) { text_field :location, label: "Localização Física" }
        col(sm: 4) { number_field :weight_grams, label: "Peso (g)" }
      end
    end
  end

  params do |params|
    params.require(:product).permit(
      :name, :code, :description, :category_id, :supplier_id,
      :brand, :price, :cost, :stock_quantity, :min_stock,
      :weight_grams, :warranty, :barcode, :location, :aasm_state,
      :image
    )
  end
end
