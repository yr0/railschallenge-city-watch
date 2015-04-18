Rails.application.routes.draw do
  resources :responders, except: [:new, :edit]
  resources :emergencies, except: [:new, :edit]
  match '*all', to: 'application#not_found', via: [:get, :patch, :delete]
end
