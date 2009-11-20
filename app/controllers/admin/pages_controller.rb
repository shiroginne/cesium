class Admin::PagesController < AdminController

  menu_position 1

  helper_method :expand, :leaves

  def index
    @pages = Page.find :all, :conditions => "level_cache in (0, 1)#{ "or parent_id in (#{expand.join(',')})" unless expand.empty?}"
  end

  def collapse
    expand.clear
    redirect_to admin_pages_path
  end

  def show
    @page = Page.find params[:id]
    @pages = @page.descendants.scoped(:conditions => { :parent_id => [params[:id]] + expand })
    expand params[:id], :save unless @pages.empty?
  end

  def hide
    expand params[:id], :remove
  end

  def move
    @page = Page.find(params[:id])
    parent_id = @page.parent_id

    params[:mode] = 'child' unless ['left', 'right'].include? params[:mode]

    @page.send "move_to_#{params[:mode]}_of".to_sym, params[:where]

    @page.rebuild_paths
    @pages = @page.self_and_descendants.scoped(:select => "id, path")

    @parent = Page.find parent_id
    expand @parent.id, :remove if @parent.leaf?

    if params[:mode] == 'child' && !expand.include?(params[:where])
      @siblings_to = @page.siblings
      expand params[:where], :save
    end
  end

  def status
    @page = Page.find(params[:id])
    @page.update_attributes(:status => params[:status]) if params[:status]
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
    @parent_id = params[:page][:parent_id]
    if @page.save
      if @parent_id
        @page.move_to_child_of @parent_id
        expand @parent_id, :save
      end
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
    parent_id = @page.parent_id
    @page.destroy

    @parent = Page.find parent_id
    expand @page.parent_id, :remove if @parent.leaf?

    respond_to do |format|
      format.html { redirect_to admin_pages_url }
      format.js
    end
  end

  private

  def expand id = nil, action = nil
    id = id.to_i
    session[:expanded] = [] unless session.has_key?(:expanded)
    case action
    when :save then
      session[:expanded] << id
    when :remove then
      session[:expanded].delete(id)
    else
      return session[:expanded]
    end
    session[:expanded].uniq!
  end

end
