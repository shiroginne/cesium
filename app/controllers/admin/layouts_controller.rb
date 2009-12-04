unless Cesium.config[:own_controllers]

  class Admin::LayoutsController < Abstract::LayoutsController
    unloadable

    cesium_admin_controller do |c|
      c.position = 2
    end
  end

end
