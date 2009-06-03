class Admin::PagesController < ApplicationController
  before_filter :require_admin

  layout 'admin'

  def index
    @pages = Page.find :all
  end

  def show
    @pages = Page.find(params[:id]).descendants
    render :action => :index
  end

  def new
    @page = Page.new unless Page.exists? :parent_id => nil
  end

  def new_sub
    @page = Page.new
    @parent_id = params[:id]
  end

  def edit
    @page = Page.find params[:id]
  end

  def create
    @page = Page.new(params[:page])
    @parent_id = params[:parent_id]
    if @page.save
      @page.move_to_child_of @parent_id if @parent_id
      @page.rebuild_paths
      flash[:notice] = 'Page was successfully saved.'
      if params[:commit] == 'Save and exit'
        redirect_to admin_pages_url
      else
        redirect_to edit_admin_page_url @page
      end
    else
      if @parent_id
        render :action => "new_sub" 
      else
        render :action => "new"
      end
    end
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      @page.rebuild_paths
      flash[:notice] = 'Page was successfully updated.'
      if params[:commit] == 'Save and exit'
        redirect_to admin_pages_url
      else
        redirect_to edit_admin_page_url @page
      end
    else
      render :action => "edit"
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to admin_pages_url }
      format.js
    end
  end
end
