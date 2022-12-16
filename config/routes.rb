Rails.application.routes.draw do
  resources :channels
  resources :discussions do
    resources :replies
  end

  root 'discussions#index'

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
