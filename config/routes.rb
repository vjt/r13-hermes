Hermes::Application.routes.draw do
  devise_for :users

  root :to => 'sites#index'

  resources :sites do
    resources :tips
  end

  get "/messages.js"        => "messages#index"
  put "/messages/:type/:id" => "messages#update"
end
