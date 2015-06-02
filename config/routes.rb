class ActionDispatch::Routing::Mapper

  def draw(routes_name)
    instance_eval(
      File.read(
        Rails.root.join("config/routes/#{routes_name}.rb")
      )
    )
  end

end

Jumpstart::Application.routes.draw do

  draw :devise

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  unauthenticated do
    get "/logout" => redirect("/")
  end

  authenticate :user, ->(u) { u.super_admin? } do
    draw :delayed_job
    draw :superadmin
  end

  draw :contacts
  draw :pages
  draw :plan
  draw :teams

  authenticated :user do
    get "/pages" => "pages#index", as: :pages
    draw :subscriber
    draw :users
    resource :subscription, only: [:new, :edit, :update]
  end

  draw :api
  draw :stripe

  root "home#show"

  resource :credit_card, only: [:new, :update]

  get "dashboard" => "home#index", as: :dashboard
  get "join" => "subscriptions#new", as: :join
end
