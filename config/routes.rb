Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               invitations: "users/invitations"
             }

  devise_scope :user do
    post "admin/users/:id/reinvite",
         to: "users/invitations#reinvite",
         as: :admin_reinvite_user
  end

  root to: "home#index"

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    get "products/search", to: "products#search", as: :product_search
    resources :reports, only: [] do
      collection do
        get  :sales
        get  :stock
        get  :cash_flow
        post :sale_pdf
        post :product_label
      end
    end
  end

  get "up", to: "rails/health#show", as: :rails_health_check
end
