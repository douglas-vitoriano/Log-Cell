# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #
# Example:
# #
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "--- Iniciando Seeds ---"

PaperTrail.enabled = false if defined?(PaperTrail)

# 1. Usuário Administrador
print "Criando Admin... "
admin_email = ENV.fetch("ADMIN_EMAIL", "logcell@logcell.xyz")
unless User.exists?(email: admin_email)
  User.create!(
    email:                 admin_email,
    name:                  ENV.fetch("ADMIN_NAME", "Administrador"),
    password:              ENV.fetch("ADMIN_PASS", "Teste123"),
    password_confirmation: ENV.fetch("ADMIN_PASS", "Teste123"),
    document:              ENV.fetch("ADMIN_DOC", "000.000.000-00"),
    phone:                 "(11) 00000-0000"
  )
end
puts "OK!"

# 2. Grupos de Acesso
print "Criando Grupos... "
groups_data = [
  { id: "5627aeec-ddad-4f78-9dfb-af182f410ea3", code: "sysadmin", name: "Administrador" },
  { id: "924919cf-0c51-472f-b8bc-7a685c3f9f47", code: "partner",  name: "Sócio" },
  { id: "2521c2c5-931e-4fb2-bc15-5f6abb822063", code: "manager",  name: "Gerente" },
  { id: "ea00fc45-8abc-4845-b1a1-91a3918aa440", code: "operator", name: "Operador" }
]

groups_data.each do |data|
  Group.find_or_create_by!(code: data[:code]) do |g|
    g.id      = data[:id]
    g.name    = data[:name]
    g.enabled = true
  end
end
puts "OK!"

# 3. Categorias
print "Criando Categorias... "
categories_map = {
  "Games"        => "🎮", "Headsets"  => "🎧", "Fones"        => "🎵",
  "Som"          => "🔊", "Controles" => "🕹️", "Brinquedos"   => "🧸",
  "Acessórios"   => "📱", "Carregadores" => "🔌", "Periféricos" => "⌨️",
  "Cabos"        => "🔗", "Capinhas"  => "📲", "Mochilas"     => "🎒",
  "Cestas"       => "🎁"
}

categories_map.each do |name, icon|
  Category.find_or_create_by!(name: name) { |c| c.icon = icon }
end
puts "OK!"

# 4. Fornecedor
print "Criando Fornecedor... "
supplier = Supplier.find_or_create_by!(cnpj: "12869788000156") do |s|
  s.company_name = "Tech Import Ltda."
  s.contact_name = "Marcos Silva"
  s.phone        = "(11) 3333-1111"
  s.city         = "São Paulo"
  s.state        = "SP"
  s.payment_days = 30
  s.lead_time    = 15
end
puts "OK!"

# 5. Produtos
print "Criando Produtos com código estruturado (P + Cat + Nanoid)... "
products_data = [
  { name: "Elden Ring - PS5", category: "Games", cost: 180.00, price: 299.90, stock: 5 },
  { name: "Zelda: Tears of the Kingdom", category: "Games", cost: 210.00, price: 349.90, stock: 3 },
  { name: "Headset HyperX Cloud II", category: "Headsets", cost: 250.00, price: 449.90, stock: 10 },
  { name: "Headset Logitech G733", category: "Headsets", cost: 400.00, price: 799.90, stock: 4 },
  { name: "AirPods Pro", category: "Fones", cost: 800.00, price: 1499.00, stock: 2 },
  { name: "Galaxy Buds 2", category: "Fones", cost: 300.00, price: 549.90, stock: 8 },
  { name: "JBL Flip 6", category: "Som", cost: 350.00, price: 629.90, stock: 6 },
  { name: "Caixa de Som Echo Dot 5", category: "Som", cost: 180.00, price: 349.00, stock: 15 },
  { name: "Controle DualSense PS5", category: "Controles", cost: 280.00, price: 429.00, stock: 7 },
  { name: "Controle Xbox Series Carbon", category: "Controles", cost: 260.00, price: 399.90, stock: 5 },
  { name: "LEGO Star Wars Millennium Falcon", category: "Brinquedos", cost: 450.00, price: 899.90, stock: 2 },
  { name: "Boneco Funko Pop Iron Man", category: "Brinquedos", cost: 45.00, price: 99.90, stock: 20 },
  { name: "Suporte Vertical PS5", category: "Acessórios", cost: 40.00, price: 89.90, stock: 12 },
  { name: "Hub USB-C 7 em 1", category: "Acessórios", cost: 85.00, price: 179.90, stock: 10 },
  { name: "Carregador Apple 20W USB-C", category: "Carregadores", cost: 90.00, price: 199.00, stock: 15 },
  { name: "Power Bank Anker 20000mAh", category: "Carregadores", cost: 120.00, price: 259.90, stock: 8 },
  { name: "Teclado Mecânico Keychron K2", category: "Periféricos", cost: 400.00, price: 749.90, stock: 3 },
  { name: "Mouse Logitech MX Master 3S", category: "Periféricos", cost: 350.00, price: 629.00, stock: 5 },
  { name: "Cabo HDMI 2.1 2m", category: "Cabos", cost: 35.00, price: 79.90, stock: 25 },
  { name: "Cabo Lightning Original 1m", category: "Cabos", cost: 50.00, price: 129.00, stock: 30 },
  { name: "Capa Silicone iPhone 15", category: "Capinhas", cost: 15.00, price: 49.90, stock: 40 },
  { name: "Capa Magnética iPad Air", category: "Capinhas", cost: 45.00, price: 119.90, stock: 15 },
  { name: "Mochila Dell Pro Slim 15", category: "Mochilas", cost: 110.00, price: 219.90, stock: 6 },
  { name: "Mochila Gamer Predator", category: "Mochilas", cost: 190.00, price: 389.00, stock: 4 },
  { name: "Cesta Café da Manhã Premium", category: "Cestas", cost: 120.00, price: 249.90, stock: 2 },
  { name: "Cesta de Natal Corporativa", category: "Cestas", cost: 150.00, price: 329.00, stock: 0 }
]

products_data.each do |attrs|
  cat = Category.find_by!(name: attrs[:category])

  generated_nanoid = Nanoid.generate(size: 8)
  cat_ref = cat.name[0].upcase
  structured_code = "P#{cat_ref}#{generated_nanoid}"

  Product.find_or_create_by!(name: attrs[:name]) do |p|
    p.category       = cat
    p.supplier       = supplier
    p.code           = structured_code
    p.cost_cents     = (attrs[:cost]  * 100).to_i
    p.price_cents    = (attrs[:price] * 100).to_i
    p.stock_quantity = attrs[:stock]
    p.min_stock      = 5
  end
end
puts "OK!"

puts "--- Criando Regras de Acesso (Rules) ---"

rules_matrix = {
  "sysadmin" => {
    Rule::RESOURCES => Rule::ACTIONS
  },
  "partner" => {
    %w[groups]  => %w[read update],
    %w[rules]   => %w[read],
    %w[users]   => %w[read create update destroy],
    %w[products categories suppliers] => Rule::ACTIONS,
    %w[sales sale_items customers]    => Rule::ACTIONS,
    %w[movements accounts_payable accounts_receivable] => Rule::ACTIONS
  },
  "manager" => {
    %w[products categories]           => %w[read create update],
    %w[suppliers]                     => %w[read],
    %w[sales sale_items customers]    => Rule::ACTIONS,
    %w[movements]                     => %w[read create],
    %w[accounts_receivable]           => %w[read],
    %w[accounts_payable]              => %w[read],
    %w[groups rules users]            => %w[read]
  },
  "operator" => {
    %w[products]                      => %w[read],
    %w[sales sale_items customers]    => %w[read create],
    %w[movements]                     => %w[read create]
  }
}

rules_matrix.each do |group_code, resource_actions|
  group = Group.find_by!(code: group_code)

  resource_actions.each do |resources, actions|
    Array(resources).each do |resource|
      Array(actions).each do |action|
        Rule.find_or_create_by!(group: group, resource: resource, action: action) do |r|
          r.enabled = true
        end
      end
    end
  end

  print "  [#{group.name}] "
  puts "#{group.rules.count} regras criadas"
end

puts "--- Rules OK! ---"
puts "--- Seeds Finalizados com Sucesso! ---"
