Rails.application.routes.draw do
  defaults format: 'json' do
    resources :responders, except: [:new, :edit]
    resources :emergencies, except: [:new, :edit]
  end

  match '*all', to: 'application#not_found', via: [:get, :patch, :delete]
end
