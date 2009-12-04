unless Cesium.config[:own_controllers]

  class Admin::PagesController < Abstract::PagesController
    unloadable

    cesium_admin_controller do |c|
      c.position = 1
    end
  end

end
