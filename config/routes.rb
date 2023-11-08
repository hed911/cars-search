require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :cars, only:[] do
    collection do
      get :search
    end
  end

  mount Sidekiq::Web => "/sidekiq"
end
