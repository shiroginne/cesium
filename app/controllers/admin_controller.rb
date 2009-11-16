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

  def process_filters
    session[:filters] = {} unless session.key?(:filters)
    session[:filters][model_name.to_sym] = {} unless session[:filters].key?(model_name.to_sym)
    if params[:order] && field_exists?(params[:order])
      case session[:filters][model_name.to_sym][:order]
      when params[:order] then
        session[:filters][model_name.to_sym][:order] = "#{params[:order]} DESC"
      when "#{params[:order]} DESC" then
        session[:filters][model_name.to_sym].delete(:order)
      else
        session[:filters][model_name.to_sym][:order] = params[:order]
      end
    end
    #if params[:filter] && respond_to?(:filter_fields)
      #condition_string = filter_fields.map{|ff| "#{ff} like ?"}.join(' or ')
      #conditions = [condition_string, *filter_fields.count.times.collect{"%#{params[:filter]}%"}]
    #end
    redirect_to request.referer if params[:order] || params[:conditions]
  end

  def field_exists? order
    if order.include? '.'
      match = order.scan(/\A(\w+)\.(\w+)\Z/)[0]
      mod = match[0].classify.constantize
      col = match[1]
    else
      mod = model
      col = order
    end
    mod && mod.columns.detect { |c| c.name == col }
  end

end
