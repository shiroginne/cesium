class PagesController < ApplicationController

  def show
    path = "/#{params[:url].join('/')}"
    page = Page.find_page(path)
    if page && !page.draft?
      text = page.build_page
      p text
      render :inline => text, :locals => { :page => page }, :layout => false
    else
      if path == '/'
        redirect_to admin_pages_url
      else
        render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      end
    end
  end

end
