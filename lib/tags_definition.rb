# To change this template, choose Tools | Templates
# and open the template in the editor.

class TagError < StandardError
end

class UndefinedPagePartError < StandardError
  def initialize(page_name)
    super("there is no page part '#{page_name}' for this page")
  end
end

class UndefinedSnippetError < StandardError
  def initialize(page_name)
    super("there is no snippet '#{page_name}'")
  end
end

module TagsDefinition

  def lazy_find_snippet name
    @snippets = {} if !@snippets
    unless @snippets[name]
      @snippets[name] = Snippet.find_by_name name
    end
    @snippets[name]
  end

  def define_tags context

    context.define_tag 'description' do |tag|
      tag.locals.page.description ? "<meta name=\"description\" content=\"#{CGI.escapeHTML(tag.locals.page.description)}\">" : ''
    end

    context.define_tag 'keywords' do |tag|
      tag.locals.page.keywords ? "<meta name=\"keywords\" content=\"#{CGI.escapeHTML(tag.locals.page.keywords)}\">" : ''
    end

    context.define_tag 'title' do |tag|
      tag.locals.page.title
    end

    context.define_tag 'include' do |tag|
      if tag.locals.page.page_parts && tag.attr['name']
        part = tag.locals.page.page_parts.detect{ |p| p.name == tag.attr['name'] } || tag.locals.page.additional_parts.detect{ |p| p.name == tag.attr['name'] }
      end
      if part
        tag.locals.page.parse part.body
      else
        raise UndefinedPagePartError.new(tag.attr['name'])
      end
    end

    context.define_tag 'snippet' do |tag|
      snippet = lazy_find_snippet tag.attr['name']
      if snippet
        tag.locals.page.parse snippet.body
      else
        raise UndefinedSnippetError.new(tag.attr['name'])
      end
    end
    
    context.define_tag 'function' do |tag|
      #(tag.attr['params'] ? PageFunctions.send(tag.attr['name'].to_sym, *tag.attr['params'].sub(' ', '').split(',')) : PageFunctions.send(tag.attr['name'].to_sym)).to_s
      PageFunctions.send(tag.attr['name'].to_sym, tag.locals.page).to_s
    end
    
    context.define_tag 'comment' do |tag|
    end

    context.define_tag 'navigation' do |tag|
      tag.locals.navigation = {}
      navigation = tag.locals.navigation
      
      if tag.nesting.include?('navigation') && tag.locals.current
        tree = tag.locals.current
      else
        for_page = tag.attr.has_key?('for') ? tag.attr['for'] : nil
        for_level = tag.attr.has_key?('level') && tag.attr['level'].to_i >= 0 ? tag.attr['level'] : nil
        
        if for_page
          pages = Page.find(for_page.to_i).self_and_descendants.scoped(:include => :page_parts)
        elsif for_level
          case for_level.to_i
          when 0
            pages = Page.root.self_and_descendants.scoped(:include => :page_parts)
          else
            pages = tag.locals.page.self_and_ancestors[for_level.to_i].self_and_descendants.scoped(:include => :page_parts)
          end
        elsif tag.attr.blank?
          pages = tag.locals.page.self_and_descendants.scoped(:include => :page_parts)
        else

        end
        tree = pages.to_a.build_tree_from_nested_set
      end

      result = []
      tree.child_pages.each do |page|
        unless page.hidden? || page.draft?
          navigation[:title] = page.title
          navigation[:url] = page.path
          tag.locals.current = page

          tag.expand

          raise TagError.new("`navigation' tag must include a `normal' tag") unless navigation.has_key? :normal

          if tag.locals.page.path == navigation[:url]
            result << (navigation[:here] || navigation[:normal]).call
          elsif tag.locals.page.path.include?(navigation[:url])
            result << (navigation[:nested] || navigation[:here] || navigation[:normal]).call
          else
            result << navigation[:normal].call
          end
        end
      end
      divider = navigation.has_key?(:divider) ? navigation[:divider].call : ' '
      result = result.join(divider)
      unless result.empty?
        before = navigation.has_key?(:before) ? navigation[:before].call : ''
        after = navigation.has_key?(:after) ? navigation[:after].call : ''
        result = before + result + after
      end
      result
    end

    [:normal, :here, :nested, :divider, :before, :after].each do |symbol|
      context.define_tag "navigation:#{symbol}" do |tag|
        navigation = tag.locals.navigation
        navigation[symbol] = tag.block
      end
    end
    
    [:url, :title].each do |symbol|
      context.define_tag "navigation:#{symbol}" do |tag|
        navigation = tag.locals.navigation
        navigation[symbol]
      end
    end

    context.define_tag 'breadcrumps' do |tag|
      tag.locals.breadcrumps = {}
      breadcrumps = tag.locals.breadcrumps

      tag.expand

      pages = tag.locals.page.self_and_ancestors.scoped(:include => :page_parts)

      if tag.attr.has_key?('mode')
        pages[-1] = nil if tag.attr['mode'].include?('noleaf')
        pages[0] = nil if tag.attr['mode'].include?('noroot')
      end

      result = []
      pages.each do |page|
        if page
          breadcrumps[:title] = page.title
          breadcrumps[:url] = page.path
          tag.locals.current = page

          raise TagError.new("`breadcrumps' tag must include a `normal' tag") unless breadcrumps.has_key? :normal

          if tag.locals.page.path == breadcrumps[:url]
            result << (breadcrumps[:here] || breadcrumps[:normal]).call
          else
            result << breadcrumps[:normal].call
          end
        end
      end
      divider = breadcrumps.has_key?(:divider) ? breadcrumps[:divider].call : ' '
      result = result.join(divider)
      unless result.empty?
        before = breadcrumps.has_key?(:before) ? breadcrumps[:before].call : ''
        after = breadcrumps.has_key?(:after) ? breadcrumps[:after].call : ''
        result = before + result + after
      end
      result
    end

    [:normal, :here, :divider, :before, :after].each do |symbol|
      context.define_tag "breadcrumps:#{symbol}" do |tag|
        breadcrumps = tag.locals.breadcrumps
        breadcrumps[symbol] = tag.block
      end
    end

    [:url, :title].each do |symbol|
      context.define_tag "breadcrumps:#{symbol}" do |tag|
        breadcrumps = tag.locals.breadcrumps
        breadcrumps[symbol]
      end
    end

    [:navigation, :breadcrumps].each do |symbol|
      context.define_tag "#{symbol}:include" do |tag|
        if tag.attr['name']
          part = tag.locals.current.page_parts.detect{ |p| p.name == tag.attr['name'] }
          part.body if part
        end
      end
    end
    
  end
    
end
