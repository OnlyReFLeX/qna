Rails.application.routes.draw do
  resources :questions, only: [:new, :show, :create] do
    resources :answers, only: :create, shallow: true
  end
end
