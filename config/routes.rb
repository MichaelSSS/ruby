Rails.application.routes.draw do
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  root 'static_pages#home'

  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'

  get 'contacts' => 'static_pages#contacts'
  
  get 'signup' => 'users#new'
  
  resources :users do
    member do
      get :following, :followers
    end
  end
  
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

end
