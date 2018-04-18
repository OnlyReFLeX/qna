Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, only: [:new, :show, :create, :index] do
    resources :answers, only: [:create], shallow: true
  end
end
