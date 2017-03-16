Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'users'
  get 'test' => 'test_secured#test'
  resources :quizzes, only: [:show, :index, :create, :update, :edit, :destroy] do
    member do
      post 'check', to: :check
      post 'save', to: :save
      post 'for_groups', to: :for_groups
      post 'publish', to: :publish
      post 'submit', to: :submit
      get 'start', to: :start
    end
    collection do
      get 'mine'
    end
  end

  resources :groups, only: [:show, :index, :create, :destroy] do
    member do
      post 'add', to: :add
      delete 'delete', to: :delete
      get 'quizzes', to: :quizzes
      post 'quizzes_update'
      get 'students', to: :students
      post 'users_update', to: :users_update
    end
  end

  resources :users, only: [:create, :update] do
    collection do
      post 'search', to: :search
    end
  end

  namespace :users do
   resources :mine, only: [:none], controller: "mine" do
     collection do
       get 'groups'
       get 'quizzes'
     end
   end
  end
end
