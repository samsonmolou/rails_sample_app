# frozen_string_literal: true

Rails.application.routes.draw do
  root "static_pages#home"

  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  get "sessions/new"
  post "sessions/create"
  delete "sessions/destroy"

  resources :users
  resources :account_activations, only: %i[edit]
  resources :password_resets, only: %i[new create edit update]
  resources :microposts, only: %i[create destroy]
end
