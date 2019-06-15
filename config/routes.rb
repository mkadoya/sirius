Rails.application.routes.draw do
  resources :tags
  resources :movies
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    get '/admin', to: 'admins#index', as: :user_root
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'admin' => "admins#index"
  get 'admin/index' => "admins#index"
  post 'admin/update' => "admins#update"
  get 'admin/new' => "admins#new"
  post 'admin/create' => "admins#create"
  resources :articles
  resources :images
  get 'items/show/:item_id' => "items#show"
  get 'results/index'
  post 'results/new' => "results#new"
  # get 'questions/index' => "questions#index"
  get 'questions/category/:category' => "questions#category"
  get 'questions/category' => "questions#category"
  get "home/movie" => "home#movie"
  get "home/movie/:id" => "home#show"
  get "/" => "home#top"
end
