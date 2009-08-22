class Admin::LayoutsController < ApplicationController
  before_filter :require_cesium_admin
  
  layout 'admin'
  
  def index
    @layouts = Layout.find :all
  end

  def new
    @layout = Layout.new
  end

  def edit
    @layout = Layout.find params[:id]
  end

  def create
    @layout = Layout.new params[:layout]
    if @layout.save
      flash[:notice] = 'Layout was successfully created.'
      if params[:commit] == 'Save and exit'
        redirect_to admin_layouts_url
      else
        redirect_to edit_admin_layout_url @layout
      end
    else
      render :action => "new"
    end
  end

  def update
    @layout = Layout.find params[:id]
    if @layout.update_attributes params[:layout]
      flash[:notice] = 'Layout was successfully updated.'
      if params[:commit] == 'Save and exit'
        redirect_to admin_layouts_url
      else
        redirect_to edit_admin_layout_url @layout
      end
    else
      render :action => "edit"
    end
  end

  def destroy
    @layout = Layout.find params[:id]
    @layout.destroy
    redirect_to admin_layouts_url
  end
end
