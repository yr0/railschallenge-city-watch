Rails.application.routes.draw do
  match '*all', to: 'application#not_found', via: [:get]
end
