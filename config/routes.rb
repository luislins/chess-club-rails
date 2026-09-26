Rails.application.routes.draw do
  root "rooms#index"

  get  "welcome", to: "welcome#show"
  post "welcome", to: "welcome#create"

  resources :rooms, only: %i[index create show destroy], param: :slug do
    member do
      get :state
    end
    resource  :seat,        only: %i[create destroy]
    resources :moves,       only: :create
    resource  :resignation, only: :create
    resources :messages,    only: :create
    resource  :prediction,  only: :create
  end

  get "hoje", to: "rank#show", as: :rank
  get "hall", to: "hall#index", as: :hall
  get "dias/:day", to: "hall#show", as: :day, constraints: { day: /\d{4}-\d{2}-\d{2}/ }

  resource :nickname, only: :update

  namespace :admin do
    root "rooms#index"

  get  "welcome", to: "welcome#show"
  post "welcome", to: "welcome#create"
    resources :rooms, only: %i[index destroy], param: :slug do
      collection { post :cleanup }
      member     { post :clear_chat }
    end
    post "close_day", to: "rooms#close_day", as: :close_day
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
