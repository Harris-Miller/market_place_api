require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users
  # Api definitions
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, contraints: ApiConstraints.new(version: 1, default: true) do
      # We are going to list our resources here
      resources :users, :only => [:show]
    end
  end

  resources :example, :only => [:show]
end
