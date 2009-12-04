unless Cesium.config[:own_controllers]

  class Admin::SnippetsController < Abstract::SnippetsController
    unloadable

    cesium_admin_controller do |c|
      c.position = 3
    end
  end

end
