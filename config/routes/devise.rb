devise_for :users, controllers: {
  registrations: "registrations",
  omniauth_callbacks: "omniauth_callbacks"
}

# Authentication
devise_scope :user do
  get "/login" => "devise/sessions#new", as: :login
  get "/logout" => "sessions#destroy", :as => :logout
  get "/signup" => "registrations#new", :as => :signup
  scope "my" do
    get "profile", to: "registrations#edit"
    put "profile/update", to: "registrations#update"
    get "password/edit", to: "registrations#edit_password"
    put "password/update", to: "registrations#update_password"
  end
end
