Rails.application.routes.draw do
  get '/contributions/newest' => 'contributions#newest'
  resources :contributions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  root 'contributions#index'
end
