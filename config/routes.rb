Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

      # users api
      get "/users", to: "users#index"
      post "/users", to: "users#sign_up"
      post "/users/login", to: "users#login"
      patch "/users/:id", to: "users#update"
      delete "/users/:id", to: "users#destroy"

      # newsfeeds api
      get "/newsfeeds", to: "newsfeeds#index"
      post "/newsfeeds", to: "newsfeeds#create"
      patch "/newsfeeds/:id", to: "newsfeeds#update"
      delete "/newsfeeds/:id", to: "newsfeeds#destroy"

      # events api
      get "/events", to: "events#index"
      post "/events", to: "events#create"
      patch "/events/:id", to: "events#update"
      delete "/events/:id", to: "events#destroy"

      #password
      post "/passwords/forgot", to: "passwords#forgot"
      post "/passwords/reset", to: "passwords#reset"
      post "/passwords/update", to: "passwords#update"
    end
  end
end
