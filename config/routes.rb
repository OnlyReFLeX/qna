Rails.application.routes.draw do
  resources :questions, only: [:new, :show, :create, :index] do
    resources :answers, only: [:new, :create], shallow: true
  end
end
