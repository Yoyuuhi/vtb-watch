Rails.application.routes.draw do
  get 'mylists/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "mylists#index"
end
