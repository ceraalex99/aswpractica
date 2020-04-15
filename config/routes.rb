Rails.application.routes.draw do
  resources :posts do
    collection do
      get 'newest'
      get 'ask'
      get 'my_submissions'
    end
    member do
      delete '' => 'contributions#destroy'
      post '' => 'comments#create'
    end
  end
  resources :users
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
  root 'posts#index'
end
