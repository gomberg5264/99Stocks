Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'headlines#home'
  get '/dashboard' => 'headlines#dashboard', as: 'dashboard'
  get '/dashboard/stocks/:id' => 'headlines#single', as: 'single'
  get '/dashboard/search' => 'headlines#search', as: 'search'
  get '/dashboard/news' => 'headlines#news', as: 'news'
end
