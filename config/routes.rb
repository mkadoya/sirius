Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  resources :articles
  resources :images
  get 'items/show/:item_id' => "items#show"
  get 'results/index'
  post 'results/new' => "results#new"
  # get 'questions/index' => "questions#index"
  get 'questions/category/:category' => "questions#category"
  get 'questions/category' => "questions#category"
  get "/" => "home#top"
end
