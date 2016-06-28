require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users

  # Api definitions
  # namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
  namespace :api, defaults: { format: :json } do
    # scope module: :v1, contraints: ApiConstraints.new(version: 1, default: true) do
    scope module: :v1 do
      # We are going to list our resources here
      resources :users, :only => [:show, :create, :update, :destroy] do
        resources :products, :only => [:create, :update, :destroy]
        resources :orders, :only => [:index, :show]
      end
      resources :sessions, :only => [:create, :destroy]
      resources :products, :only => [:index, :show]
    end
  end

end
