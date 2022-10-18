Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :voted do
    member do
      patch :like
      patch :dislike
    end
  end

  concern :commented do
    member do
      post :comment
    end
  end

  namespace :users do
    get '/set_email', to: 'emails#new'
    post '/set_email', to: 'emails#create'
  end

  resources :questions, concerns: %i[voted commented] do
    resources :answers, concerns: %i[voted commented], shallow: true, except: %i[index] do
      patch 'update_best', on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :votes, only: :destroy
  resources :badges, only: :index
  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
