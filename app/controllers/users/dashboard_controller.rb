module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
      redirect_to "/admin"
    end
  end
end
