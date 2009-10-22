module PagesHelper

  def render_snippet name
    path = request.path_info
    p path
    Snippet.find_snippet path, name
  end

end
