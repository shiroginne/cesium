module Cesium
  module Extensions
    module ActionView
      module Base

        def render_snippet name
          render :inline => Snippet.find_snippet(request.path_info, name)
        end

        def admined_controllers &block
          admined_controllers_list.sort { |a,b| a.cesium_config.position <=> b.cesium_config.position }.each do |c|
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
              begin
                c = controller_name.constantize
              rescue Exception
              else
                if c.cesium_admin?
                  condition = c.cesium_config.condition
                  p c
                  p c.cesium_config
                  condition = case condition
                              when Proc then condition.bind(controller).call
                              when Symbol then controller.send condition
                              else condition
                              end
                  controllers << c if condition
                end
              end
            end
          end
          controllers.uniq
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

        def link_to_logout
          link_to 'logout', admin_logout_url, :method => :delete if cesium_admin_session
        end

      end
    end
  end
end
