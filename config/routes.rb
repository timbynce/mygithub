Rails.application.routes.draw do
  devise_for :users

  concern :voted do
    member do
      patch :like
      patch :dislike
      delete :cancel
    end
  end

  resources :questions, concerns: %i[voted] do
    resources :answers, concerns: %i[voted], shallow: true, except: %i[index] do
      patch 'update_best', on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :votes, only: :destroy
  resources :badges, only: :index
  root to: 'questions#index'
end
