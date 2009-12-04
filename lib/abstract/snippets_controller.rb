class Abstract::SnippetsController < CesiumController::Base
  unloadable

  def index
    @snippets = Snippet.find :all
  end

  def new
    @snippet = Snippet.new
  end

  def edit
    @snippet = Snippet.find params[:id]
  end

  def create
    @snippet = Snippet.new params[:snippet]
    if @snippet.save
      flash[:notice] = 'Snippet was successfully created.'
      if params[:commit] == 'Save and exit'
        redirect_to admin_snippets_url
      else
        redirect_to edit_admin_snippet_url @snippet
      end
    else
      render :action => "new"
    end
  end

  def update
    @snippet = Snippet.find params[:id]
    if @snippet.update_attributes params[:snippet]
      flash[:notice] = 'Snippet was successfully updated.'
      if params[:commit] == 'Save and exit'
        redirect_to admin_snippets_url
      else
        redirect_to edit_admin_snippet_url @snippet
      end
    else
      render :action => "edit"
    end
  end

  def destroy
    @snippet = Snippet.find params[:id]
    @snippet.destroy
    redirect_to admin_snippets_url
  end
end
