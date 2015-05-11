ActiveAdmin.routes(self)
namespace :superadmin do
  root to: "users#index"
  resources :users
end
