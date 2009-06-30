class ApplicationController < ActionController::Base

  helper_method :current_user_session, :current_user, :admined_controllers
  filter_parameter_logging :password, :password_confirmation

private

  def admined_controllers &block
    (RAILS_ENV == 'development' ? admined_controllers_list : AdminController.subclasses).each do |c|
      block.call(c.constantize.controller_name.humanize, polymorphic_path([:admin, c.constantize.controller_name.classify.constantize.new]))
    end
  end

  def admined_controllers_list
    controllers = []
    glob = RAILS_ROOT + '/app/controllers/admin/*_controller.rb'
    Dir.glob(glob).each do |f|
      file = File.basename(f).gsub( /^(.+).rb/, '\1')
      controllers << "admin/#{file}".camelize
    end
    controllers
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      return false
    end
  end

  def require_admin
    unless current_user && current_user.admin
      store_location
      flash[:notice] = "You must be admin to access this page"
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to '/'
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
