ActionController::Routing::Routes.draw do |map|

  map.namespace :admin do |admin|
    admin.root :controller => :pages
    admin.resources :pages, :member => { :new_sub => :get } do |pages|
      pages.resources :page_parts
    end
    admin.resources :layouts
    admin.resources :snippets
    admin.resources :users
  end

  map.resource :user_session, :as => :session
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'

end
