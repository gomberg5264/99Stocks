Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'headlines#home'
  get '/dashboard' => 'headlines#dashboard', as: 'dashboard'
  get '/dashboard/stocks/:id' => 'headlines#single', as: 'single'
end
