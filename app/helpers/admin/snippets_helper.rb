module Admin::SnippetsHelper

  def snippet name
    uri = URI::parse(request.url)
    path = uri.path.gsub(/\/$/, '')
    page = Page.find_page path
    snippet = Snippet.find_by_name name
    page.parse(snippet.body)
  end

end
