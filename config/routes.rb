Rails.application.routes.draw do
  devise_for :users
  resources :friends
  # resources :home

  # orignal root pafe is this
  # root "home#index"
  root "friends#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'home/about'
  # Defines the root path route ("/")
  # root "articles#index"
end



