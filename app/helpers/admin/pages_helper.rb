module Admin::PagesHelper

  def add_page_part_link(name, form)
    link_to_function name do |page|
      task = render :partial => 'page_part', :object => PagePart.new({:name => 'new_part'}), :locals => { :f => form }
      page << %{
        var new_id = "new_" + new Date().getTime();
        $('parts').insert({ bottom: "#{ escape_javascript task }".replace(/new_index/g, new_id) });
        window.tabs.addTab($('parts').childElements().last());
      }
    end
  end

  def recursive_tree_output(set, options = {})
    prev_level = -1
    result = "<ul class=\"#{options[:class]}\" id=\"#{options[:id]}\">\n"

    set.each do |node|
      level = node.level_cache
      result += "<ul>\n" if level > prev_level && prev_level != -1
      result += "</li>\n" if level == prev_level
      (prev_level-level).times { |i| result += "</li>\n</ul>\n" } if level < prev_level
      result += "</li>\n" if level < prev_level
      result += "<li id=\"page_#{node.id}\">\n"

      result += render :partial => options[:partial], :object => node

      prev_level = level
    end

    (prev_level + 1).times { |i| result += "</li>\n</ul>\n" }
    result
  end

  def status_select page
    select_tag "page_status_#{page.id}",
      options_for_select(page.statuses, page.status),
      :onchange => "setStatus('#{status_admin_page_path(page)}', #{page.id})"
  end

  def layouts_for_select
    layouts = Layout.find(:all, :select => "id, name").collect { |l| [l.name, l.id] }
    @parent_id || @page.parent_id ?
      [["<inherited (#{Page.find(@parent_id || @page.parent_id).self_and_ancestors.scoped(:select => 'layouts.name', :joins => :layout).last.name})>", nil]] + layouts : layouts
  end

end
