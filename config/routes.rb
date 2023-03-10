Rails.application.routes.draw do
  get 'users/index'
  devise_for :users
  resources :friends
  resources :home
  resources :users
  resource :user
  # orignal root pafe is this
  # root "home#index"
  root "friends#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'home/about'
  get 'user/id', to: 'user#show'
  # Defines the root path route ("/") 
  # root "articles#index"
      # devise_for :users, :controllers => { registrations:'users/registrations',}
end



