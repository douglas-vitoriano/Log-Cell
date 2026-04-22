module PunditAuthorizable
  extend ActiveSupport::Concern

  included do
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError,              with: :pundit_not_authorized
    rescue_from Pundit::AuthorizationNotPerformedError,  with: :pundit_authorization_not_performed

    after_action :verify_authorized,      except: :index, unless: :trestle_controller?
    after_action :verify_policy_scoped,   only:   :index, unless: :trestle_controller?

    before_action :authenticate_user!
  end

  private

  def trestle_controller?
    is_a?(Trestle::ResourceController) || is_a?(Trestle::Controller)
  end

  def pundit_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore.humanize
    flash[:error] = I18n.t(
      "pundit.not_authorized",
      policy: policy_name,
      default: "Você não tem permissão para realizar esta ação em: #{policy_name}."
    )
    redirect_back fallback_location: root_path
  end

  def pundit_authorization_not_performed
    raise unless trestle_controller?
  end
end
