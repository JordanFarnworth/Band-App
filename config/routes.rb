Rails.application.routes.draw do
  root to: 'dashboard#index'
  get 'login' => 'login#index'
  post 'login' => 'login#verify'
  delete 'login' => 'login#logout'
end
