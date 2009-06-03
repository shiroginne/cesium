class Admin::UsersController < ApplicationController
  before_filter :require_admin
  
  layout 'admin'

  def index
    @users = User.find :all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find params[:id]
  end

  def create
    @user = User.new params[:user]
    if @user.save
      flash[:notice] = 'Account was successfully created.'
      if params[:commit] == 'Save and exit'
        redirect_to admin_users_url
      else
        redirect_to edit_admin_user_url @user
      end
    else
      render :action => "new"
    end
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes params[:user]
      flash[:notice] = 'Account was successfully updated.'
      if params[:commit] == 'Save and exit'
        redirect_to admin_users_url
      else
        redirect_to edit_admin_user_url @user
      end
    else
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy
    redirect_to admin_users_url
  end
end
