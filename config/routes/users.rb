match "/users/:id/finish_signup" => "users#finish_signup", via: [:get, :patch], as: :finish_signup
resources :users, controller: "users", only: [:update]
