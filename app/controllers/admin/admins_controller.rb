unless Cesium.config[:own_auth]

  class Admin::AdminsController < CesiumController::Base
    unloadable

    cesium_admin_controller do |c|
      c.position = 4
    end

    def index
      @admins = Admin.find :all
    end

    def new
      @admin = Admin.new
    end

    def edit
      @admin = Admin.find params[:id]
    end

    def create
      @admin = Admin.new params[:admin]
      if @admin.save
        flash[:notice] = 'Account was successfully created.'
        if params[:commit] == 'Save and exit'
          redirect_to admin_admins_url
        else
          redirect_to edit_admin_admin_url @admin
        end
      else
        render :action => "new"
      end
    end

    def update
      @admin = Admin.find params[:id]
      if @admin.update_attributes params[:admin]
        flash[:notice] = 'Account was successfully updated.'
        if params[:commit] == 'Save and exit'
          redirect_to admin_admins_url
        else
          redirect_to edit_admin_admin_url @admin
        end
      else
        render :action => "edit"
      end
    end

    def destroy
      @admin = Admin.find params[:id]
      @admin.destroy
      redirect_to admin_admins_url
    end
  end

end
