Rails.application.routes.draw do
  get 'questions/index'
  get 'questions/new'
  get "/" => "home#top"
  get "/category" => "home#category"
  get 'home/top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
