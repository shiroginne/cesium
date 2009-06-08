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
    prev_level = 0
    result = "<ul class=\"#{options[:class]}\" id=\"#{options[:id]}\">\n"

    set.each do |node|
      level = node.level_cache
      result += level == prev_level ? "</li>\n" : (level > prev_level ? "<ul>\n" : '')
      (prev_level-level).times { result += "</li>\n</ul>\n" } if level < prev_level
      result += "<li id=\"page_#{node.id}\">\n"

      result += render :partial => options[:partial], :object => node

      prev_level = level
    end

    (prev_level + 1).times { result += "</li>\n</ul>\n" }
    result
  end

  def layouts_for_select
    layouts = Layout.all.collect { |l| [l.name, l.id] }
    @parent_id || @page.parent_id ? [['<inherited>', nil]] + layouts : layouts
  end
  
end
