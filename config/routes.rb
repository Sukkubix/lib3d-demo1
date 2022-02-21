Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    resources :images, only: %i(show)
    resources :projects, only: %i(index) do
      post "assets", as: :assets, action: :assets
      post "generated", as: :generated, action: :generated
    end
    post "projects/checkout"
  end
end
