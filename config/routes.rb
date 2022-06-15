Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "/", :to => "orders#index"
  post :create_order, :to => "orders#create_order"
  post :capture_order, :to => "orders#capture_order"
  # Defines the root path route ("/")
  # root "articles#index"
end
