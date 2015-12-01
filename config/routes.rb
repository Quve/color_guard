Rails.application.routes.draw do
  namespace :color_guard do
    root to: 'features#index'
  end
end
