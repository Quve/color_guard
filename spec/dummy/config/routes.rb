Rails.application.routes.draw do
  root to: 'application#index'

  mount ColorGuard::Engine => "/color_guard"
end
