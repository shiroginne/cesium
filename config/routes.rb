ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|
    admin.root :controller => :pages
    admin.resources :pages, :except => :show, :member => { :new_sub => :get, :move => :get }
    admin.resources :layouts, :except => :show
    admin.resources :snippets, :except => :show
    admin.resources :admins, :except => :show
    admin.resource :admin_session, :as => :session
    admin.login 'login', :controller => 'admin_sessions', :action => 'new'
    admin.logout 'logout', :controller => 'admin_sessions', :action => 'destroy'
  end

end
