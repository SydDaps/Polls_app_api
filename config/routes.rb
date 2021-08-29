Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :organizer, only: [:create]
      resource :token, only: [:create]

      resources :polls, only: [:create, :index]

      resources :polls do
        resources :sections, only: [:create]
      end
      
    end

    
  end
end
