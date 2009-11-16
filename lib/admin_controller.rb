class AdminController < ApplicationController
  include Cesium::App::Controllers::AdminController

  unloadable

  layout 'admin'
  before_filter :require_cesium_admin, :process_filters

  def index
    if model.respond_to? :paginate
      @records = model.paginate(:page => params[:page])
    else
      @records = model.find(:all, session[:filters][model_name.to_sym])
    end
    render_action :index
  end

  def show
    @record = model.find params[:id]
    render_action :show
  end

  def new
    @record = model.new
    render_action :new
  end

  def edit
    @record = model.find params[:id]
    render_action :edit
  end

  def create
    @record = model.new params[model_name]
    if @record.save
      flash[:notice] = "#{model_name.humanize} was successfully created."
      redirect_to :action => 'index'
    else
      render_action :new
    end
  end

  def update
    @record = model.find params[:id]
    if @record.update_attributes params[model_name]
      flash[:notice] = "#{model_name.humanize} was successfully updated."
      redirect_to :action => 'index'
    else
      render_action :edit
    end
  end

  def destroy
    @record = model.find params[:id]
    @record.destroy
    redirect_to :action => 'index'
  end

  

end
