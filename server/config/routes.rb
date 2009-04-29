ActionController::Routing::Routes.draw do |map|
  map.resources :snapshots
  map.resources :feed_items
  map.resources :reel_items

  map.root :controller => 'feed_items', :action => :new

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
