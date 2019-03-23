Rails.application.routes.draw do
  get 'option_results/index'
  get 'options/get' => "options#get"
  get 'items/show/:item_id' => "items#show"
  get 'results/index'
  get 'results/index2'
  get 'results/create' => "results/create"
  get 'questions/index' => "questions#index"
  get 'questions/result' => "questions#result"
  get "/" => "home#top"
  get "/category" => "home#category"
  get 'home/top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
