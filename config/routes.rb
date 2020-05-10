Rails.application.routes.draw do
  devise_for :users
  post '/users/:id/mylists/new' => 'mylists#create'
  root "mylists#index"
  resources :users, only: [:edit, :update] do
    resources :mylists
  end
  resources :vtubers, only: [:index, :update, :show]
end