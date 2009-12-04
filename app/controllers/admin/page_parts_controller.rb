unless Cesium.config[:own_controllers]

  class Admin::PagePartsController < Abstract::PagePartsController
    unloadable
  end

end
