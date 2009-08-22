class Admin::AdminSessionsController < ApplicationController
  layout 'admin'
  
  before_filter :require_no_admin, :only => [:new, :create]
  before_filter :require_admin, :only => :destroy

  def new
    @admin_session = AdminSession.new
  end

  def create
    @admin_session = AdminSession.new(params[:admin_session])
    if @admin_session.save
      redirect_back_or_default '/'
    else
      render :action => :new
    end
  end

  def destroy
    current_admin_session.destroy
    redirect_to admin_login_url
  end
end