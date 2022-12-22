Rails.application.routes.draw do
  namespace :api do
    draw :v1
  end
  draw :staff
  resources :users
  get "welcome/index"
  root "welcome#index"
end
