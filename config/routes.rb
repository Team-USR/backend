Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  get 'test' => 'test_secured#test'
  resources :quizzes, only: [:show, :index, :create, :update, :edit] do
    member do
      post 'check', to: :check
      post 'save', to: :save
      post 'submit', to: :submit
    end
    collection do
      get 'mine'
    end
  end

  resources :users, only: [:create]
  resources :groups, only: [:show, :index, :create] do
    member do
      post 'add', to: :add
      delete 'delete', to: :delete
    end
  end
  resources :users, only: [:create, :update]
end
