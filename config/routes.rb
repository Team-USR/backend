Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  get 'test' => 'test_secured#test'
  resources :quizzes, only: [:show, :index, :create] do
    member do
      post 'check', to: :check
      post 'save', to: :save
      post 'for_groups', to: :for_groups
    end
  end

  resources :users, only: [:create]
  resources :groups, only: [:show, :index, :create] do
    member do
      post 'add', to: :add
      delete 'delete', to: :delete
      get 'quizzes', to: :quizzes
    end
  end
  resources :users, only: [:create, :update]

  namespace :v2 do
    resources :quizzes, only: [:show, :index, :create, :new] do
      member do
        post 'check', to: :check
      end
    end
  end
end
