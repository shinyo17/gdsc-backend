namespace :staff do
  get "index" => "staff#index"
  get "" => "staff#index"

  resources :users
  resources :staff_users
  resources :staff_comments do
    collection do
      post :mark_as_read
    end

    member do
      post :mark_as_checked
    end
  end
  resources :read_comments
  resources :check_comments
end
