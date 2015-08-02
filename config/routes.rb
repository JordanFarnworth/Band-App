Rails.application.routes.draw do
  root to: 'dashboard#index'
  get 'login' => 'login#index'
  post 'login' => 'login#verify'
  delete 'login' => 'login#logout'

  scope :api, defaults: { format: :json }, constraints: { format: :json } do
    scope :v1 do
      resources :users, except: [:new, :edit]
      resources :bands, except: [:new, :edit]
    end
  end
end
