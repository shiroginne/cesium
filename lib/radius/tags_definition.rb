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

class UnknownRenderOption < StandardError
  def initialize
    super("unknown render option")
  end
end

module Radius
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
        "<meta name=\"description\" content=\"#{CGI.escapeHTML(tag.locals.page.parse tag.locals.page.description)}\" />" if tag.locals.page.description
      end

      context.define_tag 'keywords' do |tag|
        "<meta name=\"keywords\" content=\"#{CGI.escapeHTML(tag.locals.page.parse tag.locals.page.keywords)}\" />" if tag.locals.page.keywords
      end

      context.define_tag 'title' do |tag|
        tag.locals.page.parse tag.locals.page.title
      end

      context.define_tag 'render' do |tag|
        case
        when tag.attr.key?('part') then
          part = tag.locals.page.all_parts.detect{ |p| p.name == tag.attr['part'] }
          if part
            tag.locals.page.parse part.body
          else
            raise UndefinedPagePartError.new(tag.attr['part'])
          end
        when tag.attr.key?('partial') then
          tag.locals.tag_tracker.wrap "<%= render :partial => \"#{tag.attr['partial']}\" %>"
        when tag.attr.key?('snippet') then
          snippet = lazy_find_snippet tag.attr['snippet']
          if snippet
            tag.locals.page.parse snippet.body
          else
            raise UndefinedSnippetError.new(tag.attr['snippet'])
          end
        when tag.attr.key?('cell') then
          tag.locals.tag_tracker.wrap "<%= render_cell :#{tag.attr['cell']}, :#{tag.attr['action']} %>" if tag.attr.has_key?('action')
        else
          raise UnknownRenderOption
        end
      end

      context.define_tag 'yield' do |tag|
        tag.locals.tag_tracker.wrap "<%= yield #{":#{tag.attr['name']} " if tag.attr['name']}%>"
      end

      context.define_tag 'field' do |tag|
        object = tag.attr.has_key?('object') ? ":@#{tag.attr['object']}" : '"@#{params[:controller].to_s.singularize}".to_sym'
        name = tag.attr['name']
        field = <<-CODE
          <%= object = instance_variable_get(#{object})
              object.#{name} if object.class.cesium_allowed_methods.include?(:#{name}) %>
        CODE
        tag.locals.tag_tracker.wrap field if name
      end

      context.define_tag 'textile' do |tag|
        ::RedCloth.new(tag.expand).to_html
      end

      context.define_tag 'markdown' do |tag|
        ::BlueCloth::new(tag.expand).to_html
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
            pages = Page.find(for_page.to_i).self_and_descendants
          elsif for_level
            case for_level.to_i
            when 0
              pages = Page.root.self_and_descendants
            else
              pages = tag.locals.page.self_and_ancestors[for_level.to_i].self_and_descendants
            end
          elsif tag.attr.blank?
            pages = tag.locals.page.self_and_descendants
          else

          end
          tree = pages.to_a.build_tree_from_nested_set
        end

        result = []
        tree.child_pages.each do |page|
          unless page.hidden? || page.draft?
            navigation[:title] = tag.locals.page.parse page.title
            navigation[:path] = page.path
            navigation[:url] = tag.locals.tag_tracker.wrap "<%= cesium_path #{page.path.to_string_path_params} %>"
            navigation[:name] = page.name
            tag.locals.current = page

            tag.expand

            raise TagError.new("`navigation' tag must include a `normal' tag") unless navigation.has_key? :normal

            if tag.locals.page.path == navigation[:path]
              result << (navigation[:here] || navigation[:normal]).call
            elsif tag.locals.page.path.include?(navigation[:path]) && navigation[:path] != '/'
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

      [:url, :title, :name].each do |symbol|
        context.define_tag "navigation:#{symbol}" do |tag|
          navigation = tag.locals.navigation
          navigation[symbol]
        end
      end

      context.define_tag 'breadcrumbs' do |tag|
        tag.locals.breadcrumbs = {}
        breadcrumbs = tag.locals.breadcrumbs

        tag.expand

        pages = tag.locals.page.self_and_ancestors

        if tag.attr.has_key?('mode')
          pages[-1] = nil if tag.attr['mode'].include?('noleaf')
          pages[0] = nil if tag.attr['mode'].include?('noroot')
        end

        result = []
        pages.each do |page|
          if page
            breadcrumbs[:title] = tag.locals.page.parse page.title
            url = page.path.include?('*') ? "<%= request.path_info.scan(/^(#{page.path.gsub(/\//, '\/').gsub(/\*/, '[\w-]+')})/)[0] %>" : "<%= cesium_path #{page.path.to_string_path_params} %>"
            breadcrumbs[:path] = page.path
            breadcrumbs[:url] = tag.locals.tag_tracker.wrap url
            breadcrumbs[:name] = page.name
            tag.locals.current = page

            raise TagError.new("`breadcrumbs' tag must include a `normal' tag") unless breadcrumbs.has_key? :normal

            if tag.locals.page.path == breadcrumbs[:path]
              result << (breadcrumbs[:here] || breadcrumbs[:normal]).call
            else
              result << breadcrumbs[:normal].call
            end
          end
        end
        divider = breadcrumbs.has_key?(:divider) ? breadcrumbs[:divider].call : ' '
        result = result.join(divider)
        unless result.empty?
          before = breadcrumbs.has_key?(:before) ? breadcrumbs[:before].call : ''
          after = breadcrumbs.has_key?(:after) ? breadcrumbs[:after].call : ''
          result = before + result + after
        end
        result
      end

      [:normal, :here, :divider, :before, :after].each do |symbol|
        context.define_tag "breadcrumbs:#{symbol}" do |tag|
          breadcrumbs = tag.locals.breadcrumbs
          breadcrumbs[symbol] = tag.block
        end
      end

      [:url, :title, :name].each do |symbol|
        context.define_tag "breadcrumbs:#{symbol}" do |tag|
          breadcrumbs = tag.locals.breadcrumbs
          breadcrumbs[symbol]
        end
      end

      [:navigation, :breadcrumbs].each do |symbol|
        context.define_tag "#{symbol}:include" do |tag|
          if tag.attr['name']
            part = tag.locals.current.page_parts.detect{ |p| p.name == tag.attr['name'] }
            part.body if part
          end
        end
      end

    end

  end
end
