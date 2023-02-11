namespace :v1 do
  resource :authorizations do
    collection do
      post :check_signed_up
      post :login
      post :sign_up
      post :token_refresh
    end
  end

  resources :users

  resources :posts
end
