ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|
    admin.root :controller => :pages
    admin.resources :pages, :member => { :new_sub => :get } do |pages|
      pages.resources :page_parts
    end
    admin.resources :layouts
    admin.resources :snippets
    admin.resources :admins
    admin.resource :admin_session, :as => :session
    admin.login 'login', :controller => 'admin_sessions', :action => 'new'
    admin.logout 'logout', :controller => 'admin_sessions', :action => 'destroy'
  end

end

ActionController::Routing::Routes.add_configuration_file(File.join(File.dirname(__FILE__), 'last_route.rb'))
