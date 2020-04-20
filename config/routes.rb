Rails.application.routes.draw do
  devise_for :users
  
  post '/users/:id/mylists/new' => 'mylists#create'
  root "mylists#index"
  resources :users, only: [:edit, :update] do
    resources :mylists, only: [:index, :new, :create, :edit, :update, :show] do

      resources :vtubers, only: [:show]
    end
  end
  resources :vtubers, only: [:index, :new, :create, :edit, :update]
end