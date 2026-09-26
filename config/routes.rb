Rails.application.routes.draw do
  devise_for :users
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  root "posts#index"
  resources :posts, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    resources :applications, only: [:new, :create]
  end
end
