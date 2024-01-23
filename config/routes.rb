# config/routes.rb

Rails.application.routes.draw do
  resources :users
  resources :daily_records do
    collection do
      get 'report'
    end
  end
end
