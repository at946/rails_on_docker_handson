Rails.application.routes.draw do
  root 'static_pages#home'

  get   '/sign_up',  to: 'users#new',    as: :sign_up
  post  '/sign_up',  to: 'users#create', as: :create_user
  resources :users, only: [:show]

  get     '/sign_in',   to: 'sessions#new',     as: :sign_in
  post    '/sign_in',   to: 'sessions#create',  as: :create_session
  delete  '/sign_out',  to: 'sessions#destroy', as: :sign_out
  
  get '/posts', to: 'posts#index', as: :posts
end
