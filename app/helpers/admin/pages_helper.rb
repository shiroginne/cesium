module Admin::PagesHelper

  def page_parts_links page, current_part = nil
    result = ''
    page.all_parts.each do |part|
      result += '<li>'
      result += link_to h(part.name), edit_admin_page_page_part_path(page, part), :class => (current_part && current_part == part ? 'selected' : nil)
      if part.additional?
        result += link_to image_tag('admin/duplicate.png'), duplicate_admin_page_page_part_path(page, part)
      else
        result += link_to image_tag('admin/remove.png'), admin_page_page_part_path(page, part), :method => :delete, :confirm => 'Are you sure?'
      end
      result += '</li>'
    end
    result
  end

  def recursive_tree_output(set, options = {})
    prev_level = set.first.level_cache - 1
    result = options[:without_root] ? '' : "<ul#{" class=\"#{options[:class]}\"" if options[:class]}#{" id=\"#{options[:id]}\"" if options[:id]}>\n"

    set.each do |node|
      level = node.level_cache
      next if level - prev_level > 1
      result += "<ul>\n" if level > prev_level && prev_level != -1
      result += "</li>\n" if level == prev_level
      (prev_level-level).times { |i| result += "</li>\n</ul>\n" } if level < prev_level
      result += "</li>\n" if level < prev_level
      result += "<li id=\"page_#{node.id}\">\n"

      result += render :partial => options[:partial], :object => node

      prev_level = level
    end

    (prev_level - set.first.level_cache + 1).times { |i| result += "</li>\n</ul>\n" }
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

  def link_to_collapse id
    link_to_remote '&minus;', :url => hide_admin_page_path(id), :method => :get
  end

  def link_to_expand id
    link_to_remote '+', :url => admin_page_path(id), :method => :get
  end

end
