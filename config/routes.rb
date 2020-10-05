Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  resources :posts do 
    resources :comments
  end
  post 'authenticate', to: 'authentication#authenticate'
  get 'users/current',to: 'users#show'
  get "search", to: "search#index"
end
