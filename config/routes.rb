Rails.application.routes.draw do

  resources :interactions do
    member do
      post '' => 'interactions#reply'
    end
  end

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
      get 'user_comments'
      get 'upvoted_submissions'
      get 'upvoted_comments'
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

  resources :comments

  namespace :api, defaults: {format: 'json'} do
    resources :posts do
      member do
        put 'like' => 'api/contributions#like'
        delete 'unlike' => 'api/contributions#unlike'
      end
    end
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  root 'posts#index'
end
