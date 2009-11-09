class Admin::PagesController < AdminController

  menu_position 1

  def index
    @pages = Page.all
  end

  def move
    @page = Page.find(params[:id])

    params[:mode] = 'child' unless ['left', 'right'].include? params[:mode]
    @page.send "move_to_#{params[:mode]}_of".to_sym, params[:where]

    @page.rebuild_paths
    @pages = @page.self_and_descendants.scoped(:select => "id, path")
  end

  def status
    @page = Page.find(params[:id])
    @page.update_attribute(:status, params[:status]) if params[:status]
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
      @page.move_to_child_of @parent_id if @parent_id
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
    @page.destroy

    respond_to do |format|
      format.html { redirect_to admin_pages_url }
      format.js
    end
  end
end
