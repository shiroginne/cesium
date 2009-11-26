module Cesium
  module Extentions
    module ActionView
      module Base

        def render_snippet name
          render :inline => Snippet.find_snippet(request.path_info, name)
        end

        def admined_controllers &block
          admined_controllers_list.map! { |c| c.constantize }.reject { |c| c.menu_position == 0}.sort! { |a,b| a.menu_position <=> b.menu_position }.each do |c|
            c = c.controller_name
            block.call(c.humanize, send("admin_#{c}_path".to_sym)) if respond_to?("admin_#{c}_path".to_sym)
          end
        end

        def admined_controllers_list
          controllers_paths = $LOAD_PATH.select { |path| path.match(/\/controllers$/) }
          controllers = []
          controllers_paths.each do |path|
            Dir.glob(File.join(path, 'admin', '*_controller.rb')).each do |f|
              file = File.basename(f).gsub( /^(.+)\.rb/, '\1')
              controller_name = "admin/#{file}".camelize
              controllers << controller_name if controller_name.constantize.superclass.controller_name == 'base'
            end
          end
          controllers
        end

        def render_field record, field
          if field[:render]
            case field[:render]
            when Symbol then send(field[:render], record)
            when Proc then field[:render].bind(self).call(record)
            else ''
            end
          else
            h(record.call_chain(field.name))
          end
        end

        def head_for field
          res = case session[:filters][controller.model_name.to_sym][:order]
                when field.order then '▾ '
                when "#{field.order} DESC" then '▴ '
                else ''
                end
          res + link_to(field.label, "?order=#{field.order}")
        end


      end
    end
  end
end
