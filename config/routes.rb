Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :organizer, only: [:create]
      resource :token, only: [:create]

      resources :polls, only: [:create, :index, :show]

      resources :polls do
        resources :sections, only: [:create, :index]
        resources :voters, only: [:create, :index]
        post 'voter/login', to: 'voters#login'

        resources :votes, only: [:create]
      end
      
    end

    
  end
end
