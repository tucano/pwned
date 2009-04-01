ActionController::Routing::Routes.draw do |map|

  map.resources :networks, 
    :collection => { :auto_complete_for_network_name => :get, 
                     :tag => :get,
                     :get_network => :get },
    :member => { :view => :get }
    
  map.resources :networks do |network|
    network.resources :comments, :collection => { :get_comments => :get }
  end

  map.root :controller => "networks"

  map.sitemap 'sitemap.xml', :controller => 'sitemap', :action => 'sitemap'
  
  map.namespace :admin do |admin|
    admin.resources :networks, :collection => { :tag => :get, :search => :get } do |network|
      network.resources :comments
    end
  end
  
  map.admin 'admin', :controller => 'admin'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
