require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }
  root 'chats#index'
  
  resources :chats, only: %i[index show create] do
    resources :messages, only: %i[create]
  end

  mount Sidekiq::Web => '/sidekiq'
end
