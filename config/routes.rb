Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  get 'test' => 'test_secured#test'
  resources :quizzes, only: [:show, :index, :create] do
    member do
      post 'check', to: :check
    end
  end
  resources :users, only: [:create]

  namespace :v2 do
    resources :quizzes, only: [:show, :index, :create, :new] do
      member do
        post 'check', to: :check
      end
    end
  end
end
