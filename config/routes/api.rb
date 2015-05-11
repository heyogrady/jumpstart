namespace :api, defaults: { format: :json } do
  namespace :v1 do
    devise_scope :user do
      post "login" => "sessions#create", as: "login"
    end

    resources :users, only: [:show, :create, :update, :destroy], constraints: { id: /.*/ }
  end
end
