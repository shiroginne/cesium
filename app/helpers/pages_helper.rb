module PagesHelper

  def render_snippet name
    render :inline => Snippet.find_snippet(request.path_info, name)
  end

end
