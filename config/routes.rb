Rails.application.routes.draw do
  root 'static_pages#home'

  get   '/sign_up',  to: 'users#new',    as: :sign_up
  post  '/sign_up',  to: 'users#create', as: :create_user
  resources :users, only: [:show]
end
