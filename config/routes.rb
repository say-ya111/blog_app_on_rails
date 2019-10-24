Rails.application.routes.draw do
  devise_for :users
  resources :articles
  root 'pages#home'
end
