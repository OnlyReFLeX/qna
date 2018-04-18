Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, only: [:new, :show, :create, :index, :destroy] do
    resources :answers, only: [:create, :destroy], shallow: true
  end
end
