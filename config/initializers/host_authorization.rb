Rails.application.config.hosts.clear
Rails.application.config.hosts << "log-cell.up.railway.app"
Rails.application.config.hosts << /.*\.up\.railway\.app/
Rails.application.config.hosts << "localhost"
Rails.application.config.hosts << "127.0.0.1"

if ENV["RAILS_ALLOWED_HOSTS"].present?
  ENV["RAILS_ALLOWED_HOSTS"].split(",").each do |host|
    Rails.application.config.hosts << host.strip
  end
end
