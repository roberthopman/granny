Rails.application.routes.draw do
  root 'public#index'
  
  resources :chats, only: %i[create show] do
    resources :messages, only: %i[create]
  end
end
