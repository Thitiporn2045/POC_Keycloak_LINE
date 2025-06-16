Rails.application.routes.draw do
  root "home#index" # 👈 หน้าแรกใหม่

  get "/login", to: "sessions#login"
  get "/auth/callback", to: "sessions#callback"
  delete "/logout", to: "sessions#logout"
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
