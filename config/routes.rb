Rails.application.routes.draw do
  devise_for :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "mylists#index"
  resources :users, only: [:edit, :update]
  resources :mylists, only: [:index, :new, :create]
end
