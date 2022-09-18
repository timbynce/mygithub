Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, only: [:new, :create, :update, :destroy] do
      patch 'update_best', on: :member
    end
  end

  root to: 'questions#index'
end
