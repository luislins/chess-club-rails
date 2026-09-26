Rails.application.routes.draw do
  root "rooms#index"

  resources :rooms, only: %i[index create show destroy], param: :slug do
    member do
      get :state
    end
    resource  :seat,        only: %i[create destroy]
    resources :moves,       only: :create
    resource  :resignation, only: :create
    resources :messages,    only: :create
  end

  resource :nickname, only: :update

  get "up" => "rails/health#show", as: :rails_health_check
end
