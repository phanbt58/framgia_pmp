Rails.application.routes.draw do
  devise_for :users, only: :session
  root "projects#index"

  resources :projects
  namespace :admin do
    root "projects#index"
    resources :projects
  end
end
