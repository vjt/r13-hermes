Hermes::Application.routes.draw do
  devise_for :users

  root :to => 'sites#index'

  resources :sites do
    resources :tips
  end

  get "/payload.js" => "scripts#show"
end
