Trestle.configure do |config|
  config.site_title = "Log Cell"
  config.theme = { primary: "#000000" }

  config.auth.backend           = :devise
  config.auth.warden.scope      = :user
  config.auth.user_class        = -> { User }
  config.auth.user_admin        = -> { :"auth/account" }
  config.auth.authenticate_with = :email
end
