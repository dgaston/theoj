Theoj::Application.routes.draw do
  resources :papers, defaults: { format: 'json' } do
    resources :annotations, defaults: { format: 'json' }
  end

  resources :users, defaults: { format: 'json' }, only: [:show] do
    resources :papers, defaults: { format: 'json' } do
      collection do
        get :as_reviewer, defaults: { format: 'json' }
        get :as_editor, defaults: { format: 'json' }
        get :as_author, defaults: { format: 'json' }
        get :as_collaborator, defaults: { format: 'json' }
      end
    end
  end

  get '/sessions/new', to: 'sessions#new', as: 'new_session'
  get '/auth/:provider/callback', to: 'sessions#create'
  get "/signout" => "sessions#destroy", :as => :signout

  root :to => 'home#index'
end