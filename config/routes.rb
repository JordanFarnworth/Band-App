Rails.application.routes.draw do

  resources :bands
  resources :users
  resources :parties

  root to: 'dashboard#index'
  get 'login' => 'login#index'
  post 'login' => 'login#verify'
  delete 'login' => 'login#logout'
  get 'register' => 'login#register'
  post 'register' => 'login#verify_register'
  get 'register/finish' => 'login#finish_registration'
  get 'register/confirm' => 'login#confirm_registration'

  post 'entities/:id/switch' => 'entities#switch', as: 'entity_switch'
  delete 'entities/cancel_view' => 'entities#cancel_view', as: 'entity_cancel_view'
  resources :messages, only: [:index]
  resources :message_threads, only: [:show]

  scope :api, defaults: { format: :json }, constraints: { format: :json } do
    scope :v1 do
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
      resources :bands, except: [:new, :edit]
      resources :entities, only: [] do
        resources :message_threads, except: [:new, :edit, :update], shallow: true do
          resources :messages, only: [:index], shallow: true
        end

        resources :messages, only: [:create]
      end
      resources :parties, except: [:new, :edit]
    end
  end
end
