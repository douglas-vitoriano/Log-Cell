class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :set_active_storage_url_options

  private

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = { host: request.base_url }
  end
end
