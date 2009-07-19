class PagesController < ApplicationController

  def show
    if params[:url].is_a? Array
      path = '/' + params[:url].join('/')
    else
      path = '/' + params[:url].to_s
    end
    page = Page.find_page path
    if page && !page.draft?
      page_layout = page.get_layout
      render :inline => page.parse(page_layout.body), :locals => { :page => page }, :layout => false
    else
      if path == '/'
        redirect_to admin_pages_url
      else
        render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      end
    end
  end

  def sitemap
    
  end

end
