Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  resources :articles
  resources :images
  get 'option_results/result'
  get 'option_results/create'
  get 'options/get' => "options#get"
  get 'items/show/:item_id' => "items#show"
  get 'results/index'
  get 'results/index2'
  get 'results/index3'
  get 'results/create' => "results/create"
  get 'questions/index' => "questions#index"
  get 'questions/option_index' => "questions#option_index"
  get 'questions/result' => "questions#result"
  get 'questions/option_result' => "questions#option_result"
  get "/" => "home#top"
end
