ActionController::Routing::Routes.draw do |map|
  map.resources :snapshots
  map.resources :messages

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
