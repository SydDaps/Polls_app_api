Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :organizer, only: [:create]
      resource :token, only: [:create]
    end
  end
end
