Rails.application.routes.draw do
  resources :articles
  get 'users/show'
  get 'users/create'
  get 'option_results/result'
  get 'option_results/create'
  get 'options/get' => "options#get"
  # get 'items/show/:item_id' => "items#show"
  get 'items/show' => "items#show"
  get 'items/series' => "items#series"
  get 'results/index'
  get 'results/index2'
  get 'results/create' => "results/create"
  get 'questions/index' => "questions#index"
  get 'questions/option_index' => "questions#option_index"
  get 'questions/result' => "questions#result"
  get 'questions/option_result' => "questions#option_result"
  # get "/" => "home#top"
  get "/" => "home#top"
  get "/category" => "home#category"
  get 'home/top'
  get 'home/description'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
