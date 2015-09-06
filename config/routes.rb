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
  resources :message_threads, only: [:show]

  scope :api, defaults: { format: :json }, constraints: { format: :json } do
    scope :v1 do
      post 'application' => 'applications#create'
      resources :events
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
      resources :entities do
        member do
          get 'events' => 'events#events'
          put 'update' => 'events#update'
        end
        resources :message_threads, except: [:new, :edit, :update], shallow: true do
          resources :messages, only: [:index], shallow: true
        end

        resources :messages, only: [:create]
      end
      resources :parties, except: [:new, :edit] do
        collection do
          get 'search'
        end
      end
    end
  end
end
