class Admin::PagePartsController < AdminController

  helper Admin::PagesHelper

  menu_position 0

  before_filter :find_page

  def duplicate
    @page_part = PagePart.find(params[:id]).clone
    @page_part.page_id = params[:page_id]
    flash[:notice] = @page_part.save ? 'Page part was successfully duplicated.' : 'Page part duplication error.'
    redirect_to edit_admin_page_page_part_url @page, @page_part
  end

  def new
    store_referer
    @page_part = @page.page_parts.new
  end

  def edit
    store_referer
    @page_part = PagePart.find params[:id]
  end

  def create
    @page_part = @page.page_parts.new params[:page_part]
    if @page_part.save
      flash[:notice] = 'Page part was successfully created.'
      if params[:commit] == 'Save and exit'
        redirect_stored_or edit_admin_page_url @page
      else
        redirect_to edit_admin_page_page_part_url @page, @page_part
      end
    else
      render :action => "new"
    end
  end

  def update
    @page_part = PagePart.find params[:id]
    if @page_part.update_attributes params[:page_part]
      flash[:notice] = 'Page part was successfully updated.'
      if params[:commit] == 'Save and exit'
        redirect_stored_or edit_admin_page_url @page
      else
        redirect_to edit_admin_page_page_part_url @page, @page_part
      end
    else
      render :action => "edit"
    end
  end

  def destroy
    @page_part = PagePart.find params[:id]
    name = @page_part.name
    @page_part.destroy
    @page.page_parts.reload
    part = @page.all_parts.detect { |p| p.name == name }
    redirect_to (part ? edit_admin_page_page_part_url(@page, part) : edit_admin_page_url(@page))
  end

  private

  def find_page
    @page = Page.find params[:page_id]
  end

end
