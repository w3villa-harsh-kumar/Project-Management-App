Rails.application.routes.draw do
  resources :user_projects
  resources :artifacts

  resources :tenants do 
    resources :projects do
      get 'users', on: :member
      put 'add_user', on: :member
    end
  end
  resources :members
  get 'home/index'

  root to: "home#index"

  as(:user) do
    match '/user/confirmation' => 'confirmations#update', via: :put, as: :update_user_confirmation
  end

  devise_for :users, :controllers => {
    :confirmations => "confirmations",
    :registrations => "registrations"
  }

  match '/plan/edit' => 'tenants#edit', via: :get, as: :edit_plan
  match '/plan/update' => 'tenants#update', via: [:put, :patch], as: :update_plan

  # Page Not Found
  get "*path", to: "pages#not_found", constraints: lambda { |req| req.path.exclude? "rails/active_storage" }
end
