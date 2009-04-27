ActionController::Routing::Routes.draw do |map|
  map.resources :snapshots
  map.resources :messages
  map.resources :reel_items

  map.root :controller => 'messages', :action => :new

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
