Rails.application.routes.draw do

  resources :bands do
    collection do
      get 'search' => 'bands#search'
    end
  end
  resources :users
  resources :parties do
    collection do
      get 'search' => 'parties#search'
    end
  end

  root to: 'dashboard#index'
  get 'login' => 'login#index'
  get 'dashboard' => 'dashboard#index'
  get 'calendar' => 'dashboard#calendar'
  get 'landing' => 'login#landing'
  get 'about' => 'dashboard#about'
  post 'login' => 'login#verify'
  delete 'login' => 'login#logout'
  get 'register' => 'login#register'
  post 'register' => 'login#verify_register'
  get 'register/finish' => 'login#finish_registration'
  get 'register/confirm' => 'login#confirm_registration'

  resources :messages, only: [:index]
  resources :events
  resources :favorites, only: [:create, :delete] do
    collection do
      post 'check_band'
      post 'check_party'
      post 'add_remove_band'
      post 'add_remove_party'
    end
  end
  resources :message_threads, only: [:show]

  scope :api, defaults: { format: :json }, constraints: { format: :json } do
    scope :v1 do
      resources :applications do
        member do
          post 'decline_app'
        end
        collection do
          post 'create'
        end
      end

      resources :notifications, only: %i(index destroy) do
        member do
          put 'mark_as_read'
        end
      end
      resources :events do
        member do
          post 'invite'
          post 'accept_invite'
          post 'decline_invite'
          put 'update'
        end
        collection do
          post 'create_accepted_event'
        end
      end
      resources :users, except: [:new, :edit] do
        member do
          get 'password_confirmation'
          put 'entity_type'
        end
        collection do
          get 'available_usernames'
          get 'available_emails'
        end
      end
      resources :bands, except: [:new, :edit] do
        collection do
          get 'search'
        end
      end
      resources :messages, only: [:create]
      resources :entities do
        member do
          get 'events' => 'events#events'
          put 'update' => 'events#update'
        end

      end
      resources :message_threads, except: [:new, :edit, :update], shallow: true do
        resources :messages, only: [:index], shallow: true
        get 'recipients', on: :collection
      end
      resources :parties, except: [:new, :edit] do
        collection do
          get 'search'
        end
      end
    end
  end
end
