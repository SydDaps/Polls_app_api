Rails.application.routes.draw do

  mount ActionCable.server => "/cable"

  namespace :api do
    namespace :v1 do
      resource :organizer, only: [:create]
      resource :token, only: [:create]





      resources :polls, only: [:create, :index, :show, :update]

      resources :polls do
        get '/analytics', to: 'polls#analytics'
        resources :sections, only: [:create, :index]
        resources :voters, only: [:create, :index]
        post 'voter/login', to: 'voters#login'
        post 'voter/publish', to: 'voters#publish'

        post 'agent/login', to: 'agents#login'

        resources :votes, only: [:create, :show]
        resources :agents, only: [:create, :index]

        get 'agent_reset_token', to: 'agents#reset_token'
        post 'agent_reset_password', to: 'agents#reset_password'
      end

    end


  end
end
