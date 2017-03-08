Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'users'
  get 'test' => 'test_secured#test'
  resources :quizzes, only: [:show, :index, :create, :update, :edit] do
    member do
      post 'check', to: :check
      post 'save', to: :save
      post 'for_groups', to: :for_groups
      post 'publish', to: :publish
    end
    collection do
      get 'mine'
    end
  end

  resources :groups, only: [:show, :index, :create] do
    member do
      post 'add', to: :add
      delete 'delete', to: :delete
      get 'quizzes', to: :quizzes
    end
  end
  resources :users, only: [:create, :update]
end
