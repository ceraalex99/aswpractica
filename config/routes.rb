Rails.application.routes.draw do
  resources :posts do
    collection do
      get 'newest'
      get 'ask'
    end
    member do
      delete '' => 'contributions#destroy'
      post '' => 'posts#comment'
    end
  end
  resources :users do
    member do
      get 'user_submissions'
    end
  end
  get '/login' => 'users#create'
  get '/logout' => 'users#logout'


  resources :contributions do
    member do
      put 'like'
      delete 'unlike'
    end
  end

  get '/my_comments ' => 'comments#my_comments'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  root 'posts#index'
end
