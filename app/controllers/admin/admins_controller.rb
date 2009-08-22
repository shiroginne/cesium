class Admin::AdminsController < ApplicationController
  before_filter :require_cesium_admin
  
  layout 'admin'

  def index
    @admins = Admin.find :all
  end

  def new
    @admin = Admin.new
  end

  def edit
    @admin = Admin.find params[:id]
  end

  def create
    @admin = Admin.new params[:user]
    if @admin.save
      flash[:notice] = 'Account was successfully created.'
      if params[:commit] == 'Save and exit'
        redirect_to admin_admins_url
      else
        redirect_to edit_admin_admin_url @admin
      end
    else
      render :action => "new"
    end
  end

  def update
    @admin = Admin.find params[:id]
    if @admin.update_attributes params[:user]
      flash[:notice] = 'Account was successfully updated.'
      if params[:commit] == 'Save and exit'
        redirect_to admin_admins_url
      else
        redirect_to edit_admin_admin_url @admin
      end
    else
      render :action => "edit"
    end
  end

  def destroy
    @admin = Admin.find params[:id]
    @admin.destroy
    redirect_to admin_admins_url
  end
end
