Rails.application.routes.draw do
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

  scope :api, defaults: { format: :json }, constraints: { format: :json } do
    scope :v1 do
      resources :users, except: [:new, :edit]
      resources :bands, except: [:new, :edit]
    end
  end
end
