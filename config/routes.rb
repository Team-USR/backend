Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  resources :quizzes, only: [:show, :index]
  resources :users, only: [:create]
end
