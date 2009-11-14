class AdminController < ApplicationController
  unloadable

  layout 'admin'

  before_filter :require_cesium_admin, :process_filters
  helper_method :pic_for

  transmit_options :index_fields, :show_fields, :form_fields, :filter_fields, :file_fields, :column_types

  class_inheritable_accessor :menu_position
  write_inheritable_attribute :menu_position, 1000

  def self.menu_position value = nil
    value ? write_inheritable_attribute(:menu_position, value) : read_inheritable_attribute(:menu_position)
  end

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

  def helpers
    @helpers ||= "Admin::#{controller_class_name}".constantize.helpers
  end

  def model
    @model ||= controller_name.classify.constantize
  end

  def model_name
    @model_name ||= controller_name.singularize
  end

  def render_action action
    result = "admin_views/#{action}.html.erb"
    view_paths.each do |path|
      result = File.join('admin', controller_name, "#{action}.html.erb") if File.exists?(File.join(path, 'admin', controller_name, "#{action}.html.erb"))
    end
    render result
  end

  def process_filters
    session[:filters] = {} unless session.key?(:filters)
    session[:filters][model_name.to_sym] = { :order => '', :conditions => {} } unless session[:filters].key?(model_name.to_sym)
    session[:filters][model_name.to_sym][:order] = "created_at DESC" if session[:filters][model_name.to_sym][:order].empty?
    if params[:order] && model.columns.detect {|c| c.name == params[:order]}
      case session[:filters][model_name.to_sym][:order]
      when params[:order] then
        session[:filters][model_name.to_sym][:order] = "#{params[:order]} DESC"
      when "#{params[:order]} DESC" then
        session[:filters][model_name.to_sym][:order] = "created_at DESC"
      else
        session[:filters][model_name.to_sym][:order] = params[:order]
      end
    end
    #if params[:filter] && respond_to?(:filter_fields)
      #condition_string = filter_fields.map{|ff| "#{ff} like ?"}.join(' or ')
      #conditions = [condition_string, *filter_fields.count.times.collect{"%#{params[:filter]}%"}]
    #end
    redirect_to request.path_info if params[:order] || params[:conditions]
  end

  def pic_for field
    case session[:filters][model_name.to_sym][:order]
    when field.to_s then '▾ '
    when "#{field} DESC" then '▴ '
    else ''
    end
  end

end
