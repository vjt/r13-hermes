Hermes::Application.routes.draw do
  devise_for :users

  root :to => 'sites#index'

  get '/crash' => 'sites#crash' # Just a test

  resources :sites do
    resources :tips, :tutorials
  end

  get "/messages.js"        => "messages#index"
  # This sucks, we know - but we're stuck with JSONP as of now
  get "/messages/:type/:id" => "messages#update", as: :message
end
