Rails.application.routes.draw do
  apipie
  mount_devise_token_auth_for 'User', at: 'users'
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

  resources :statistics, only: [:average_marks_groups] do
    collection do
      get 'average_marks_groups', to: :average_marks_groups
      get 'marks_groups_quizzes', to: :marks_groups_quizzes
    end
  end

  resources :groups, only: [:edit, :create, :destroy] do
    member do
      get 'quizzes', to: :quizzes
      post 'quizzes_update'
      get 'students', to: :students
      post 'users_update', to: :users_update
      post 'add_users', to: :add_users
      post 'request_join'
      post 'accept_join'
      post 'decline_join'
    end
    collection do
      post 'search', to: :search
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
       get 'requests'
       get 'submitted'
     end
   end
  end
end
