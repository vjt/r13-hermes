Hermes::Application.routes.draw do
  devise_for :users

  root :to => 'sites#index'

  resources :sites do
    resources :tips, :tutorials
  end

  put '/tips/:id/position'  => 'tips#position'

  get "/messages.js"        => "messages#index"
  # This sucks, we know - but we're stuck with JSONP as of now
  get "/messages/:type/:id" => "messages#update", as: :dismiss_message

  # Message preview, bypassing State check
  get "/message/:type/:id" => "messages#show",    as: :message
end
