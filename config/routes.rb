Rails.application.routes.draw do
  resources :users
  get '/contributions/newest' => 'contributions#newest'
  get '/contributions/ask' => 'contributions#ask'
  get '/login' => 'users#create'
  get '/logout' => 'users#logout'
  resources :contributions do
    member do
      put 'like'
      delete 'unlike'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  root 'contributions#index'
end
