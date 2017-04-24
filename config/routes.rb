Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: {format: 'json'} do
  	scope module: :v1 do
  		get "search" , to: "bugs#search"
  		post "bug/new", to:"bugs#create"
  		get "bug", to: "bugs#show"
  	end
  end
end
