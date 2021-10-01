Rails.application.routes.draw do

  mount ActionCable.server => "/cable"
  
  namespace :api do
    namespace :v1 do
      resource :organizer, only: [:create]
      resource :token, only: [:create]

      resources :polls, only: [:create, :index, :show]

      resources :polls do
        get '/analytics', to: 'polls#analytics'
        resources :sections, only: [:create, :index]
        resources :voters, only: [:create, :index]
        post 'voter/login', to: 'voters#login'
        post 'voter/publish', to: 'voters#publish'

        resources :votes, only: [:create, :show]
      end
      
    end

    
  end
end
