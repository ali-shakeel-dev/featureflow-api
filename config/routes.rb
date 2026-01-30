Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/v1/auth'

  namespace :api do
    namespace :v1 do
      # Public routes
      resources :ideas, only: [:index, :show] do
        collection do
          get :trending
          get :recent
        end
        resources :comments, only: [:index, :create, :destroy]
        member do
          post :vote
          delete :unvote
        end
      end

      resources :roadmap_items, only: [:index, :show]

      # Authenticated user routes
      resources :users, only: [:show, :update] do
        member do
          get :my_ideas
          get :my_votes
        end
      end

      # Admin routes
      namespace :admin do
        resources :ideas, only: [:index, :update, :destroy] do
          member do
            patch :change_status
          end
        end
        resources :roadmap_items, only: [:index, :create, :update, :destroy]
        resources :users, only: [:index, :show, :update, :destroy]
      end

      # Create idea (requires auth)
      post '/ideas', to: 'ideas#create'
    end
  end
end