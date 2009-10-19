class AdminController < ApplicationController
  unloadable

  layout 'admin'

  before_filter :require_cesium_admin

  transmit_options :index_fields, :show_fields, :form_fields, :filter_fields, :file_fields, :column_types

  def index
    conditions = nil
    if params[:filter] && respond_to?(:filter_fields)
      condition_string = filter_fields.map{|ff| "#{ff} like ?"}.join(' or ')
      conditions = [condition_string, *filter_fields.count.times.collect{"%#{params[:filter]}%"}]
    end
    if model.respond_to? :paginate
      @records = model.paginate :page => params[:page], :conditions => conditions
    else
      @records = model.find :all, :conditions => conditions
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

end
