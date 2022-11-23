require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
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

  devise_scope :user do
    post 'send_email_confirmation', to: 'oauth_callbacks#send_email_confirmation',
                                    as: :send_email_confirmation
    get 'email_confirmation/:token', to: 'oauth_callbacks#email_confirmation',
                                     as: :email_confirmation
  end

  resources :questions, concerns: %i[voted commented] do
    resources :answers, concerns: %i[voted commented], shallow: true, except: %i[index] do
      patch 'update_best', on: :member
    end
    
    resources :subscriptions, only: [:create, :destroy], shallow: true
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :votes, only: :destroy
  resources :badges, only: :index

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :all, on: :collection
      end

      resources :questions, except: [:edit, :new] do
        resources :answers, except: [:edit, :new], shallow: true
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
