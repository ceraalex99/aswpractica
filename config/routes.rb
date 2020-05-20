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
    post '/login' => '/api/users#create'
    resources :posts do
      member do
        post 'like' => '/api/contributions#like'
        delete 'like' => '/api/contributions#unlike'
        get 'comments' => '/api/comments#index'
      end
      collection do
        get 'newest'
        get 'ask'
      end
    end
    resources :users do
      member do
        get 'submissions'
        get 'comments'
        get 'upvoted_submissions'
        get 'upvoted_comments'
      end
    end
    resources :comments do
      member do
        get 'replies'
        post 'like' => '/api/contributions#like'
        delete 'like' => '/api/contributions#unlike'
      end
    end
    resources :replies do
      member do
        post 'like' => '/api/contributions#like'
        delete 'like' => '/api/contributions#unlike'
        get 'replies'
      end
    end
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  root 'posts#index'
end
