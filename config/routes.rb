Rails.application.routes.draw do
  devise_for :users
  post '/users/:id/mylists/new' => 'mylists#create'
  root "mylists#index"
  namespace :vtubers do
    resources :searches, only: :index
  end
  resources :users, only: [:edit, :update] do
    resources :mylists
  end
  resources :vtubers, only: [:update, :show]
end